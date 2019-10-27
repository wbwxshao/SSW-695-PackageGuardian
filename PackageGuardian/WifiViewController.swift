//
//  WifiViewController.swift
//  PackageGuardian
//
//  Created by godlikeMini on 9/26/19.
//  Copyright © 2019 SSW695. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
class WifiViewController: ViewController {
    
    @IBOutlet weak var addressText: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.addressText.text = address
        // Do any additional setup after loading the view.
    }
    

    @IBAction func connect(_ sender: Any) {
 
        mqttClient.connect()
        mqttClient.publish("rpi/gpio", withString: "on")
        mqttClient.publish("gps/lat", withString: String(format:"%f", lat))
        mqttClient.publish("gps/log", withString: String(format:"%f", log))
        self.alert(message: "Location \(lat), \(log) has been sent and GPS is activated!")
    }
    func alert(message:String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
