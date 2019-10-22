//
//  Users.swift
//  PackageGuardian
//
//  Created by godlikeMini on 10/21/19.
//  Copyright © 2019 SSW695. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class Users {
    let ref:DatabaseReference?
    var name : String
    var address : String
    var coordinates : String
    var phone : Any

    init(name: String, address: String, coordinates: String, phone: String) {
        self.ref = nil
        self.name = name
        self.address = address
        self.coordinates = coordinates
        self.phone = phone

    }
    typealias CompletionHandler = (_ success:Bool) -> Void
    init?(snapshot: DataSnapshot)
    {
        
        guard
        let value = snapshot.value as? [String: AnyObject],
        let name = value["name"] as? String,
        let address = value["address"] as? String,
        let coordinates = value["coordinates"] as? String,
        let phone = value["phone"] as? Any
        else{
            return nil
        }
        
        self.ref = snapshot.ref
        self.name = name
        self.address = address
        self.coordinates = coordinates
        self.phone = phone
    }
    

    
    func toAnyObject() -> Any{
        return [
            "name": name,
            "address": address,
            "coordinates": coordinates,
            "phone": phone
        ]
    }
}
