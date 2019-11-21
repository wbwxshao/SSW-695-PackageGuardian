//
//  AddressViewController.swift
//  PackageGuardian
//
//  Created by godlikeMini on 10/21/19.
//  Copyright © 2019 SSW695. All rights reserved.
//

import UIKit
import Firebase
import MBProgressHUD

var lat = ""
var log = ""
var address = ""
var code = ""
class AddressViewController: ViewController, UITableViewDelegate, UITableViewDataSource {
    
    var lists = [Users]()
    var ref: DatabaseReference?
    @IBOutlet weak var addressTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.connectDatabase()
        self.addressTable.delegate = self
        self.addressTable.dataSource = self
    }
    
    func connectDatabase(){
        self.ref = Database.database().reference()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.ref?.child("users").observe(.value, with: { (snapshot) in
            var newLists:[Users] = []
            if(snapshot.childrenCount == 0)
            {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            for child in snapshot.children
            {
                if let snap = child as? DataSnapshot, let newL = Users(snapshot: snap)
                    {
                        self.lists.append(newL)
                        self.addressTable.reloadData()
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                else{
                
                    print("error from database!")
                }
            }
            
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AddressTableViewCell
        cell.address?.text = self.lists[indexPath.row].address
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AddressTableViewCell
        address = self.lists[indexPath.row].address
        let coor = self.lists[indexPath.row].coordinates.split{$0 == ","}.map(String.init)
        lat = coor[0]
        log = coor[1]
        code = self.lists[indexPath.row].code
    }
}
