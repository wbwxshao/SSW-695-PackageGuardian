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
        
    }
    @IBAction func registerButton(_ sender: Any) {
        guard
            let name = nameField.text,
            let phone = phoneField.text,
            let address = addressField.text
        else {
            self.alert(message: "Please fill all the field before register!")
            return
        }
        let geoCoder = CLGeocoder()
         geoCoder.geocodeAddressString(address) { (placemarks, error) in
             guard
                 let placemarks = placemarks,
                 let lat = placemarks.first?.location?.coordinate.latitude,
                 let log = placemarks.first?.location?.coordinate.longitude
             else {
                 self.alert(message: "No location found!")
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
             ref.child("users").child(self.nameField.text!).setValue(info)
            self.alert(message: "Successfully registered!")
           
         }
        
    }
    
    func alert(message:String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            _ = self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

}
