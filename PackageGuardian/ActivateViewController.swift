//
//  ActivateViewController.swift
//  PackageGuardian
//
//  Created by godlikeMini on 9/13/19.
//  Copyright © 2019 SSW695. All rights reserved.
//

import UIKit
import CoreBluetooth

class ActivateViewController: UIViewController, CBPeripheralDelegate, CBCentralManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.devices.count)
        return self.devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        
        cell.textLabel?.text = self.devices[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        
        let currentCell = tableView.cellForRow(at: indexPath!) as! UITableViewCell
        self.centralManager.connect(self.deviceMap[currentCell.textLabel!.text!]!, options: nil)
        print(currentCell.textLabel!.text)
        
    }
    var devices:[String] = []{
        didSet{
            self.table.reloadData()
        }
    }
    var deviceMap = [String : CBPeripheral]()
    @IBOutlet weak var table: UITableView!
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.table.delegate = self
        self.table.dataSource = self
    }
    
    @IBAction func connect(_ sender: Any) {
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("Central state update")
        if central.state != .poweredOn {
            print("Central is not powered on")
        } else {
            centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey : false])
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        // Copy the peripheral instance
        self.peripheral = peripheral
        if let name = self.peripheral.name {
            if !self.devices.contains(name)
            {
                self.devices.append(name)
                self.deviceMap.updateValue(peripheral, forKey: name)
            }
        }
        
        //print(self.peripheral.name)
        self.peripheral.delegate = self
        
        // Connect!
        //self.centralManager.connect(self.peripheral, options: nil)
        
    }
}
