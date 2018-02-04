//
//  Popup.swift
//  ET
//
//  Created by leena hassan on 16/05/1439 AH.
//  Copyright © 1439 com.GP.ET. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class RegisterViewController: UIViewController , UITextFieldDelegate {
    
    @IBOutlet weak var SignUpbtn: UIButton!
    @IBOutlet weak var RegisterView: UIView!
    @IBOutlet weak var companyName: HoshiTextField!
    @IBOutlet weak var CommercialRecord: HoshiTextField!
    
    @IBOutlet weak var fname: HoshiTextField!
    @IBOutlet weak var lname: HoshiTextField!
    @IBOutlet weak var email: HoshiTextField!
    @IBOutlet weak var phone: HoshiTextField!
    @IBOutlet weak var username: HoshiTextField!
    @IBOutlet weak var password: HoshiTextField!
    
    @IBOutlet weak var C_SP: CustomControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fname.delegate = self
        lname.delegate = self
        email.delegate = self
        phone.delegate = self
        username.delegate = self
        password.delegate = self
        
        companyName.delegate = self
        CommercialRecord.delegate = self
        
        RegisterView.frame.origin.y=100
        RegisterView.frame.origin.x=16;
        RegisterView.layer.masksToBounds=true
        RegisterView.layer.cornerRadius=8
        RegisterView.frame.size=CGSize.init(width:347, height:512)
        SignUpbtn.frame.origin.y=462
        
    }
    
    func textFieldShouldReturn(_ textfield:UITextField)->Bool{
        textfield.resignFirstResponder()
        return true}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
   //dismiss button for log in
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //close button for register
    
    /*@IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }*/
    @IBAction func SelectUser(_ sender: CustomControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            companyName.isHidden=true
            CommercialRecord.isHidden=true
            RegisterView.frame.origin.y=100
            SignUpbtn.frame.origin.y=462
            RegisterView.frame.origin.x=16;
            RegisterView.frame.size=CGSize.init(width:343, height:512)

       print("Customer+++333")
            
        case 1:
            companyName.isHidden=false
            CommercialRecord.isHidden=false
            RegisterView.frame.origin.y=50
            RegisterView.frame.origin.x=16;
            SignUpbtn.frame.origin.y=562
            RegisterView.frame.size=CGSize.init(width:343, height:609)
        default:
            print("none")
    }

}
    
    
    @IBAction func createAccountAction(_ sender: Any) {
        
        // variable to reference our database from firebase
        let ref : DatabaseReference!
        ref = Database.database().reference()
        
        
        //check which user tree and redirect page
        let page = "C_SP_Login"
        let tree = (C_SP.selectedSegmentIndex == 0) ? "Customers":"ServiceProviders"
        var flag : Bool!
        
        switch C_SP.selectedSegmentIndex {
        case 0: //customer
            flag = self.fname.text == "" || self.lname.text! == "" || self.email.text! == "" || self.phone.text! == "" || self.username.text! == "" || self.password.text! == ""
        case 1:
            flag = self.fname.text == "" || self.lname.text! == "" || self.email.text! == "" || self.phone.text! == "" || self.username.text! == "" || self.password.text! == "" || self.companyName.text! == "" || self.CommercialRecord.text! == ""
        default:
            print("none")
        }
        
        if flag {
            //error message: fields empty
            let alertController = UIAlertController(title: "Error", message: "All fields are required. Please enter all your info.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            
        } else {
            ref.child(tree).queryOrdered(byChild: "username").queryEqual(toValue: username.text!.lowercased()).observeSingleEvent(of: .value , with: { snapshot in
                if !snapshot.exists() {
                    // Update database with a unique username.
                    
                    Auth.auth().createUser(withEmail: self.email.text!, password: self.password.text!) { (user, error) in
                        if error == nil {
                            print("You have successfully signed up")
                            // add user to the users tree
                            //and set value of email property to the value taken from textfield
                            //later on we will add more properties... e.g. username.. profile pic.. bio..
                            ref.child(tree).child(user!.uid).setValue(["firstname":self.fname.text!,"lastname":self.lname.text!,"email": self.email.text!,"phonenumber":self.phone.text!,"username": self.username.text!.lowercased(),"UID": user!.uid]
                            )
                            // redirect to login page
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: page)
                            self.present(vc!, animated: true, completion: nil)
                        } else {
                            //error message: signup failed
                            let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alertController.addAction(defaultAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                    
                }
                else {
                    //error message: username already exists
                    let alertController = UIAlertController(title: "Uh oh!", message: "\(self.username.text!) is not available. Try another username.", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                
            }) {error in print(error.localizedDescription)}
            
        }
        
        
    }
    
    
    
    
    
    
}
