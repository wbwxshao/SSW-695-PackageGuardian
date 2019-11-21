//
//  DeactivateViewController.swift
//  PackageGuardian
//
//  Created by godlikeMini on 10/15/19.
//  Copyright © 2019 SSW695. All rights reserved.
//

import UIKit
class DeactivateViewController: ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func deactivate(_ sender: Any) {
        mqttClient.connect()
        let message = "off" + " " + codeFromDatabase
        mqttClient.publish("rpi/gpio", withString: message)
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
