//
//  WifiViewController.swift
//  PackageGuardian
//
//  Created by godlikeMini on 9/26/19.
//  Copyright © 2019 SSW695. All rights reserved.
//

import UIKit
import CocoaMQTT
class WifiViewController: ViewController {
    let mqttClient = CocoaMQTT(clientID: "iOS Device", host: "192.168.4.1", port: 1883)
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func connect(_ sender: Any) {
        mqttClient.connect()
        mqttClient.publish("rpi/gpio", withString: "on")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
