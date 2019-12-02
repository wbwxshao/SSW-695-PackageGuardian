//
//  LoginViewController.swift
//  PackageGuardian
//
//  Created by godlikeMini on 11/16/19.
//  Copyright © 2019 SSW695. All rights reserved.
//

import UIKit
import Firebase
import MBProgressHUD

var codeFromDatabase = ""
class LoginViewController: UIViewController {
    var lists = [Users]()
    var ref: DatabaseReference?
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var passField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func login(_ sender: Any) {
        if(self.nameField.text!.count == 0 || self.passField.text!.count == 0){
            alert(message: "Please enter your name and password!")
        }else{
           check()
        }
    }
    
    func check(){
        guard let name = self.nameField.text else{
            return
        }
        guard let pass = self.passField.text else{
            return
        }
        self.ref = Database.database().reference()
        self.ref?.child("users").child(name).observe(.value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let receivedPass = value?["pass"] as? String ?? ""
            codeFromDatabase = value?["code"] as? String ?? ""
            print("code is \(codeFromDatabase)")
            if(pass == receivedPass)
            {
                
               let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "deactivate")
               self.navigationController?.pushViewController(vc, animated: true)
            }else{
                self.alert(message: "Name or password is incorrect! Please try again.")
            }
       })
       
       
    }
    func alert(message:String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
