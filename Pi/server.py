#!/usr/bin/env python
# -*- coding: utf-8 -*-

import paho.mqtt.client as mqtt
import time
import serial
import os
import glob
import time
import RPi.GPIO as GPIO
import threading
import json
from geopy.distance import geodesic
from datetime import datetime

LAT = ''
LOG = ''
STATUS = ''
CODE = ''
CODE2 = ''
NAME = ''
TRACE = {}
TRACE['trace'] = []
DATA = {}
#DATA['data'] = []
COUNTER = 0
os.system('modprobe w1-gpio')
os.system('modprobe w1-therm')

def connectionStatus(client, userdata, flags, rc):
    mqttClient.subscribe("rpi/gpio")
def messageDecoder(client, userdata, msg):
    global LAT
    global LOG
    global STATUS
    global CODE
    global CODE2
    global NAME
    global DATA
    message = msg.payload.decode(encoding='UTF-8')
    info = message.split() # ["ON", ]

    GPS_thread = threading.Thread(target = runGPS)
    print(info)
    STATUS= info[0]
    if info[0] == "on":
        LAT = info[1]
        LOG = info[2]
        CODE = info[3]
        NAME = info[4]
        STATUS = 'on'
        DATA[NAME] = {}
        GPS_thread.start()
    elif info[0] == "off":
        CODE2 = info[1]
        shutdownGPS()
        STATUS= 'off'
        print("GPS is OFF!")
        write_to_file()
        GPS_thread.terminate()
        
    else:
        print("Unknown message!")
        
def shutdownGPS():
    global CODE
    global CODE2
    if CODE != CODE2:
        print("The code is incorrect!")
    else:
        GPIO.output(14, GPIO.LOW)
        GPIO.output(15, GPIO.LOW)
        GPIO.output(18, GPIO.LOW)
        GPIO.output(23, GPIO.LOW)
    
def runGPS():
    global STATUS
    while STATUS!='off':
        try:
            line = readString()
            lines = line.split(",")
            if checksum(line):
                if lines[0] == "GPRMC":
                    getCode(lines)
                    pass
            else:
                print("GPS error")
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
    print("latstring is ", latString[2:])
    lat = latString[:2].lstrip('0') + "." + "%.7s" % str(float(latString[2:]) * 1.0 / 60.0).lstrip("0.")
    lng = lngString[:3].lstrip('0') + "." + "%.7s" % str(float(lngString[3:]) * 1.0 / 60.0).lstrip("0.")
    return lat, lng
    
def getCode(lines):
    latlng = getLatLng(lines[3], lines[5])
    #print("Lat,Long: ", latlng[0], lines[4], ", ", latlng[1], lines[6])
    lat = float(latlng[0])
    lng = float(latlng[1])
    calculateDistance(lat, lng)
    time.sleep(5)
        
def calculateDistance(lat, lng):
    global LAT
    global LOG
    lat2 = float(LAT)
    lon2 = float(LOG)
    write_json(lat, -lng)    #write trace to a json file
    #distance = mpu.haversine_distance((lat, lng), (lat2, lon2))
    origin = (lat, -lng)  # (latitude, longitude) don't confuse
    dist = (lat2, lon2)
    distance = geodesic(origin, dist).meters
    print("Distance is ", distance)
    #if distance > 100:
    #    GPIO.setup(18,GPIO.OUT)
    #    GPIO.output(18, GPIO.HIGH)
    #    GPIO.setup(23,GPIO.OUT)
    #    GPIO.output(23, GPIO.HIGH)
        
def write_json(lat,lon):
    global NAME
    global TRACE
    global DATA
    global COUNTER
    #data = {}
    #trace = {}
    now = datetime.now()
    dt_string = now.strftime("%d/%m/%Y %H:%M:%S")
    DATA[NAME][COUNTER] = {'timestamp':dt_string, 'lat':lat, 'lon':lon}
    COUNTER += 1

def write_to_file():
    global NAME
    global DATA
    print("data is ", DATA)
    filename = NAME + '.json'
    with open(filename, 'a') as outfile:
        json.dump(DATA, outfile)
    
if __name__ == '__main__':
    clientName = "RPI"
    serverAddress = "192.168.4.1"
    mqttClient = mqtt.Client(clientName)
    mqttClient.on_connect = connectionStatus
    mqttClient.on_message = messageDecoder

    mqttClient.connect(serverAddress)
    mqttClient.loop_forever()
