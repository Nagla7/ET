//
//  CustomerAccountViewController.swift
//  ET
//
//  Created by Reem Al-Zahrani on 07/02/2018.
//  Copyright © 2018 com.GP.ET. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class CustomerAccountViewController: UIViewController {

    @IBOutlet weak var fname: HoshiTextField!
    @IBOutlet weak var lname: HoshiTextField!
    @IBOutlet weak var email: HoshiTextField!
    @IBOutlet weak var phone: HoshiTextField!
    @IBOutlet weak var username: HoshiTextField!
    var loggedInUser:AnyObject?
    var databaseRef : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loggedInUser = Auth.auth().currentUser
        self.databaseRef = Database.database().reference()
        
        self.databaseRef.child("Customers").child(self.loggedInUser!.uid).observe(.value, with: { (snapshot) in
            let snapshot = snapshot.value as! [String: AnyObject]
            
            self.fname.text = snapshot["firstname"] as? String
            self.lname.text = snapshot["lastname"] as? String
            self.email.text = snapshot["email"] as? String
            self.phone.text = snapshot["phonenumber"] as? String
            self.username.text = snapshot["username"] as? String
        })
    }
    
    
    /*
     // Update database with new info
     
     self.databaseRef.child("Customers").child(self.loggedInUser!.uid).child("firstname").setValue(self.fname.text)
     self.databaseRef.child("Customers").child(self.loggedInUser!.uid).child("lastname").setValue(self.lname.text)
     self.databaseRef.child("Customers").child(self.loggedInUser!.uid).child("email").setValue(self.email.text)
     self.databaseRef.child("Customers").child(self.loggedInUser!.uid).child("phonenumber").setValue(self.phone.text)
     self.databaseRef.child("Customers").child(self.loggedInUser!.uid).child("username").setValue(self.username.text)
     
     FIRAuth.auth()?.currentUser?.updateEmail(email.text!) { (error) in
     // ...
     
     */
    
}
