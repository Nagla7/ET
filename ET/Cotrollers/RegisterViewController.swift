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
    @IBOutlet weak var repassword: HoshiTextField!
    
    @IBOutlet weak var C_SP: CustomControl!
    var ref : DatabaseReference!
    var userTree = ""
    
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
        
        ref = Database.database().reference()
    }
    
    func textFieldShouldReturn(_ textfield:UITextField)->Bool{
        textfield.resignFirstResponder()
        return true}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first?.view != RegisterView{self.dismiss(animated:true, completion:nil)}
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
        
        //check which user tree
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
                    Auth.auth().createUser(withEmail: self.email.text!, password: self.password.text!) { (user, error) in
                        if error == nil {
                            print("You have successfully signed up")
                            // add user info to database
                            self.ref.child(tree).child(user!.uid).setValue(["firstname":self.fname.text!,"lastname":self.lname.text!,"email": self.email.text!,"phonenumber":self.phone.text!,"username": self.username.text!.lowercased(),"UID": user!.uid]
                            )
                            // redirect to login page
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "C_SP_Login")
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
    }
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated:true, completion: nil)
    }
    
    // ================== TEXTFIELD VALIDATION ======================
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        
        if (textField == fname)
        {
            let name_reg = "[A-Za-z]{1,30}"
            let name_test = NSPredicate(format: "SELF MATCHES %@", name_reg)
            if name_test.evaluate(with: fname.text) == false
            {
                let alert = UIAlertController(title: "Format Error", message: "First name can contain letters only.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        if (textField == lname)
        {
            let name_reg = "[A-Za-z]{1,30}"
            let name_test = NSPredicate(format: "SELF MATCHES %@", name_reg)
            if name_test.evaluate(with: lname.text) == false
            {
                let alert = UIAlertController(title: "Format Error", message: "Last name can contain letters only.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        if (textField == username)
        {
            let name_reg = "[A-Za-z0-9]{5,20}"
            let name_test = NSPredicate(format: "SELF MATCHES %@", name_reg)
            if name_test.evaluate(with: username.text) == false
            {
                let alert = UIAlertController(title: "Format Error", message: "Username has to be at least 5 characters long and can contain letters and numbers.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
            
            //  check username uniqueness
            userTree = (C_SP.selectedSegmentIndex == 0) ? "Customers":"ServiceProviders"
            ref.child(userTree).queryOrdered(byChild: "username").queryEqual(toValue: username.text!.lowercased()).observeSingleEvent(of: .value , with: { snapshot in
                if snapshot.exists() {
                    //error message: username already exists
                    let alertController = UIAlertController(title: "Uh oh!", message: "\(self.username.text!) is not available. Try another username.", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }})
            
        }
        
        if (textField == password)
        {
            let name_reg = "[A-Z0-9a-z._%@+-]{6,10}"
            let name_test = NSPredicate(format: "SELF MATCHES %@", name_reg)
            if name_test.evaluate(with: password.text) == false
            {
                let alert = UIAlertController(title: "Format Error", message: "Password has to be at least 6 characters long and can contain letters, numbers and special characters ( . _ % @ + - )", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        if (textField == repassword)
        {
            let name_reg = "[A-Z0-9a-z._%@+-]{6,10}"
            let name_test = NSPredicate(format: "SELF MATCHES %@", name_reg)
            if name_test.evaluate(with: repassword.text) == false
            {
                let alert = UIAlertController(title: "Format Error", message: "Password has to be at least 6 characters long and can contain letters, numbers and special characters ( . _ % @ + - )", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
            
            if !(repassword.text == password.text){
                let alert = UIAlertController(title: "Uh oh!", message: "Passwords don't match! Please re-enter matching passwords.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        if (textField == email)
        {
            let name_reg = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let name_test = NSPredicate(format: "SELF MATCHES %@", name_reg)
            if name_test.evaluate(with: email.text) == false
            {
                let alert = UIAlertController(title: "Format Error", message: "Enter the E-mail in correct format. e.g. example@domain.com ", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        if (textField == phone)
        {
            let name_reg = "[0-9]{10}"
            let name_test = NSPredicate(format: "SELF MATCHES %@", name_reg)
            if name_test.evaluate(with: phone.text) == false
            {
                let alert = UIAlertController(title: "Format Error", message: "Phone number has to be 10 digits long.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        if (textField == companyName)
        {
            let name_reg = "[A-Za-z0-9]{1,30}"
            let name_test = NSPredicate(format: "SELF MATCHES %@", name_reg)
            if name_test.evaluate(with: companyName.text) == false
            {
                let alert = UIAlertController(title: "Format Error", message: "Company name can contain letters and numbers only.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        if (textField == CommercialRecord)
        {
            let name_reg = "[0-9]{10}"
            let name_test = NSPredicate(format: "SELF MATCHES %@", name_reg)
            if name_test.evaluate(with: CommercialRecord.text) == false
            {
                let alert = UIAlertController(title: "Format Error", message: "Commercial record has to be 10 digits long.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
}
