#!/usr/bin/env python
# -*- coding: utf-8 -*-

import paho.mqtt.client as mqtt
import time
import serial
from math import sin, cos, sqrt, atan2, radians
import os
import glob
import time
import RPi.GPIO as GPIO
LAT = ''
LOG = ''
os.system('modprobe w1-gpio')
os.system('modprobe w1-therm')

def connectionStatus(client, userdata, flags, rc):
    mqttClient.subscribe("rpi/gpio")
def messageDecoder(client, userdata, msg):
    global LAT
    global LOG
    message = msg.payload.decode(encoding='UTF-8')
    info = message.split() # ["ON", ]
    print(message)
    if info[0] == "on":
        LAT = info[1]
        LOG = info[2]
        runGPS()
        print("GPS is ON!")
    elif info[0] == "off":
        shutdownGPS()
        print("GPS is OFF!")
    else:
        print("Unknown message!")
        
def shutdownGPS():
    GPIO.output(14, GPIO.LOW)
    GPIO.output(15, GPIO.LOW)
    GPIO.output(18, GPIO.LOW)
    GPIO.output(23, GPIO.LOW)
    
def runGPS():
    #ser = serial.Serial('/dev/ttyACM0', 9600, timeout=1)  # Open Serial port
    try:
        line = readString()
        lines = line.split(",")
        if checksum(line):
            if lines[0] == "GPRMC":
                getCode(lines)
                pass
    except KeyboardInterrupt:
        print('Exiting Script')

def checksum(line):
    checkString = line.partition("*")
    checksum = 0
    for c in checkString[0]:
        checksum ^= ord(c)

    try:  # Just to make sure
        inputChecksum = int(checkString[2].rstrip(), 16);
        GPIO.setmode(GPIO.BCM)
        GPIO.setwarnings(False)
        GPIO.setup(14,GPIO.OUT)     #light green if GPS is normal
        GPIO.output(14, GPIO.HIGH)
        GPIO.setup(15,GPIO.OUT)
        GPIO.output(15, GPIO.HIGH)
    except:
        print("Error in string")
        return False

    if checksum == inputChecksum:
        return True
    else:
        print("=====================================================================================")
        print("===================================Checksum error!===================================")
        print("=====================================================================================")
        print(hex(checksum), "!=", hex(inputChecksum))
        return False

def readString():
    ser = serial.Serial('/dev/ttyACM0', 9600, timeout=1)  # Open Serial port
    while 1:
        while ser.read().decode("utf-8") != '$':  # Wait for the begging of the string
            pass  # Do nothing
        line = ser.readline().decode("utf-8")  # Read the entire string
        return line


def getTime(string, format, returnFormat):
    return time.strftime(returnFormat,
                         time.strptime(string, format))  # Convert date and time to a nice printable format


def getLatLng(latString, lngString):
    lat = latString[:2].lstrip('0') + "." + "%.7s" % str(float(latString[2:]) * 1.0 / 60.0).lstrip("0.")
    lng = lngString[:3].lstrip('0') + "." + "%.7s" % str(float(lngString[3:]) * 1.0 / 60.0).lstrip("0.")
    return lat, lng
def getCode(lines):
    latlng = getLatLng(lines[3], lines[5])
    #print("Lat,Long: ", latlng[0], lines[4], ", ", latlng[1], lines[6])
    lat = float(latlng[0])
    lng = float(latlng[1])
    calculateDistance(lat, lng)

def calculateDistance(lat, lng):
    global LAT
    global LOG
    R = 6373.0
    lat1 = radians(lat)
    lon1 = radians(lng)
    lat2 = radians(float(LAT))
    lon2 = radians(float(LOG))
    dlon = lon2 - lon1
    dlat = lat2 - lat1
    a = sin(dlat / 2)**2 + cos(lat1) * cos(lat2) * sin(dlon / 2)**2
    c = 2 * atan2(sqrt(a), sqrt(1 - a))
    distance = R * c * 1000
    print("The distance between current location and *** is {0} m. ".format(distance))
    if distance > 100:
        GPIO.setup(18,GPIO.OUT)
        GPIO.output(18, GPIO.HIGH)
        GPIO.setup(23,GPIO.OUT)
        GPIO.output(23, GPIO.HIGH)

if __name__ == '__main__':
    clientName = "RPI"
    serverAddress = "192.168.4.1"
    mqttClient = mqtt.Client(clientName)
    mqttClient.on_connect = connectionStatus
    mqttClient.on_message = messageDecoder

    mqttClient.connect(serverAddress)
    mqttClient.loop_forever()
