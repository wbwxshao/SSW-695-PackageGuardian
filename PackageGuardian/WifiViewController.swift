//
//  WifiViewController.swift
//  PackageGuardian
//
//  Created by godlikeMini on 9/26/19.
//  Copyright © 2019 SSW695. All rights reserved.
//

import UIKit
import CoreLocation
class WifiViewController: ViewController {
    
    @IBOutlet weak var addressSearch: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func connect(_ sender: Any) {
        let geoCoder = CLGeocoder()
        guard
            let address = self.addressSearch.text
        else{
            let alert = UIAlertController(title: "Alert", message: "Please enter the address!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                  switch action.style{
                  case .default:
                        print("default")

                  case .cancel:
                        print("cancel")

                  case .destructive:
                        print("destructive")


            }}))
            self.present(alert, animated: true, completion: nil)
            return
        }
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let lat = placemarks.first?.location?.coordinate.latitude,
                let log = placemarks.first?.location?.coordinate.longitude
            else {
                // handle no location found
                self.alert(message: "No location found!")
                return
            }
            print(lat, log)
            mqttClient.connect()
            mqttClient.publish("rpi/gpio", withString: "on")
            mqttClient.publish("gps/lat", withString: String(format:"%f", lat))
            mqttClient.publish("gps/log", withString: String(format:"%f", log))
            self.alert(message: "Location \(lat), \(log) has been sent and GPS is activated!")
        }
        
        
    }
    func alert(message:String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
