//
//  RegisterViewController.swift
//  PackageGuardian
//
//  Created by GodlikeMac on 2019/10/26.
//  Copyright © 2019 SSW695. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class RegisterViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let lat = placemarks.first?.location?.coordinate.latitude,
                let log = placemarks.first?.location?.coordinate.longitude
            else {
                // handle no location found
                return
            }
            var combined = "\(lat),\(log)"
            var info: [String: String] = [
                       "name": self.nameField.text!,
                       "phone": self.phoneField.text!,
                       "address": self.addressField.text!,
                       "coordinates": combined
                   ]
                   var ref: DatabaseReference!
                   ref = Database.database().reference()
                   ref.child("user").child("users").observe(.value, with: { (data) in
                       let result = data.value as! String
                       
                   })
        }
       
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
