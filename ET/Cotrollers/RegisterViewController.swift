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
    private var currentTextField: UITextField?
    var valids = Array(repeating: true, count: 11)
    
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
        repassword.delegate = self
        companyName.delegate = self
        CommercialRecord.delegate = self
        
        RegisterView.frame.origin.y=100
        RegisterView.frame.origin.x=16;
        RegisterView.layer.masksToBounds=true
        RegisterView.layer.cornerRadius=8
        RegisterView.frame.size=CGSize.init(width:347, height:512)
        SignUpbtn.frame.origin.y=462
        
        ref = Database.database().reference()
        //SignUpbtn.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textfield:UITextField)->Bool{
        textfield.resignFirstResponder()
        return true}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first?.view != RegisterView{self.dismiss(animated:true, completion:nil)}
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
    }

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
    /*
    // ================== SIGN UP BUTTON COLOR ======================
    @IBAction func textFieldDidChange(_ sender: Any) {
        print("textField: \(String(describing: currentTextField?.text))")
        //currentTextField?.resignFirstResponder()
        var textFieldsEmpty = true
        var textFieldsValid = true
        
        switch C_SP.selectedSegmentIndex {
        case 0: //customer
            textFieldsEmpty = self.fname.text == "" || self.lname.text! == "" || self.email.text! == "" || self.phone.text! == "" || self.username.text! == "" || self.password.text! == ""
           textFieldsValid = valids[0] && valids[1] && valids[2] && valids[3] && valids[4] && valids[5] && valids[6] && valids[7] && valids[8]
        case 1:
            textFieldsEmpty = self.fname.text == "" || self.lname.text! == "" || self.email.text! == "" || self.phone.text! == "" || self.username.text! == "" || self.password.text! == "" || self.companyName.text! == "" || self.CommercialRecord.text! == ""
            textFieldsValid = valids[0] && valids[1] && valids[2] && valids[3] && valids[4] && valids[5] && valids[6] && valids[7] && valids[8] && valids[9] && valids[10]
        default:
            print("none")
        }
        
        //currentTextField?.becomeFirstResponder()
        if (textFieldsValid && !textFieldsEmpty){
            SignUpbtn.backgroundColor = UIColor(red:0.13, green:0.64, blue:0.62, alpha:1.0)
            SignUpbtn.isEnabled = true
        } else {
            SignUpbtn.backgroundColor = UIColor(red:0.77, green:0.91, blue:0.91, alpha:1.0)
            SignUpbtn.isEnabled = false
        }
    }*/
    
    // ================== TEXT FIELD COLOR ======================
    func erroneousTextField(){
        (currentTextField as! HoshiTextField).borderThickness=(active: 2, inactive: 2)
        (currentTextField as! HoshiTextField).borderInactiveColor=UIColor.red
    }
    
    // ================== POP UP MESSAGE ======================
    func popUpMessage(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func createAccountAction(_ sender: Any) {
        
        if let currentTextField = currentTextField {
            currentTextField.resignFirstResponder()
        }
        
        //check which user tree
        let tree = (C_SP.selectedSegmentIndex == 0) ? "Customers":"ServiceProviders"
        var flag : Bool!
        var flag2 : Bool!
        
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
            popUpMessage(title: "Error", message: "All fields are required. Please enter all your info.")
        } else {
            
            // check all fields are valid
            switch C_SP.selectedSegmentIndex {
            case 0: //customer
                flag2 = valids[0] && valids[1] && valids[2] && valids[3] && valids[4] && valids[5] && valids[6] && valids[7] && valids[8]
            case 1:
                flag2 = valids[0] && valids[1] && valids[2] && valids[3] && valids[4] && valids[5] && valids[6] && valids[7] && valids[8] && valids[9] && valids[10]
            default:
                print("none")
            }
            if(flag2){
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
                            self.popUpMessage(title: "Error", message: (error?.localizedDescription)!)
                        }
                    }
            } else {
                popUpMessage(title: "Error", message: "Cannot submit form with invalid info. Please make sure all fields are in correct format.")
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
                valids[0] = false
                erroneousTextField()
                popUpMessage(title: "Format Error", message: "First name can contain letters only.")
            } else {
                valids[0] = true
            }
        }
        
        if (textField == lname)
        {
            let name_reg = "[A-Za-z]{1,30}"
            let name_test = NSPredicate(format: "SELF MATCHES %@", name_reg)
            if name_test.evaluate(with: lname.text) == false
            {
                valids[1] = false
                erroneousTextField()
                popUpMessage(title: "Format Error", message: "Last name can contain letters only.")
            } else {
                valids[1] = true
            }
            
        }
        
        if (textField == username)
        {
            let name_reg = "[A-Za-z0-9]{5,20}"
            let name_test = NSPredicate(format: "SELF MATCHES %@", name_reg)
            if name_test.evaluate(with: username.text) == false
            {
                valids[2] = false
                username.borderInactiveColor=UIColor.red
                erroneousTextField()
                popUpMessage(title: "Format Error", message: "Username has to be at least 5 characters long and can contain letters and numbers.")
            } else {
                valids[2] = true
            }
            
            //  check username uniqueness
            userTree = (C_SP.selectedSegmentIndex == 0) ? "Customers":"ServiceProviders"
            ref.child(userTree).queryOrdered(byChild: "username").queryEqual(toValue: username.text!.lowercased()).observeSingleEvent(of: .value , with: { snapshot in
                if snapshot.exists() {
                    self.valids[3] = false
                    self.erroneousTextField()
                    self.popUpMessage(title: "Uh oh!", message: "\(self.username.text!) is not available. Try another username.")
                } else {
                    self.valids[3] = true
                }
            })
            
        }
        
        if (textField == password)
        {
            let name_reg = "[A-Z0-9a-z._%@+-]{6,10}"
            let name_test = NSPredicate(format: "SELF MATCHES %@", name_reg)
            if name_test.evaluate(with: password.text) == false
            {
                valids[4] = false
                erroneousTextField()
                popUpMessage(title: "Format Error", message: "Password has to be at least 6 characters long and can contain letters, numbers and special characters ( . _ % @ + - )")
            } else {
                self.valids[4] = true
            }
        }
        
        if (textField == repassword)
        {
            let name_reg = "[A-Z0-9a-z._%@+-]{6,10}"
            let name_test = NSPredicate(format: "SELF MATCHES %@", name_reg)
            if name_test.evaluate(with: repassword.text) == false
            {
                valids[5] = false
                erroneousTextField()
                popUpMessage(title: "Format Error", message: "Password has to be at least 6 characters long and can contain letters, numbers and special characters ( . _ % @ + - )")
            } else {
                self.valids[5] = true
            }

            
            if !(repassword.text == password.text){
                valids[6] = false
                erroneousTextField()
                popUpMessage(title: "Uh oh!", message: "Passwords don't match! Please re-enter matching passwords.")
            } else {
                self.valids[6] = true
            }
        }
        
        if (textField == email)
        {
            let name_reg = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let name_test = NSPredicate(format: "SELF MATCHES %@", name_reg)
            if name_test.evaluate(with: email.text) == false
            {
                valids[7] = false
                erroneousTextField()
                popUpMessage(title: "Format Error", message: "Enter the E-mail in correct format. e.g. example@domain.com")
            } else {
                self.valids[7] = true
            }

        }
        
        if (textField == phone)
        {
            let name_reg = "[0-9]{10}"
            let name_test = NSPredicate(format: "SELF MATCHES %@", name_reg)
            if name_test.evaluate(with: phone.text) == false
            {
                valids[8] = false
                erroneousTextField()
                popUpMessage(title: "Format Error", message: "Phone number has to be 10 digits long.")
            } else {
                self.valids[8] = true
            }
        }
        
        if (textField == companyName)
        {
            let name_reg = "[A-Za-z0-9]{1,50}"
            let name_test = NSPredicate(format: "SELF MATCHES %@", name_reg)
            if name_test.evaluate(with: companyName.text) == false
            {
                valids[9] = false
                erroneousTextField()
                popUpMessage(title: "Format Error", message: "Company name can contain letters and numbers only.")
            } else {
                self.valids[9] = true
            }
        }
        
        if (textField == CommercialRecord)
        {
            let name_reg = "[0-9]{10}"
            let name_test = NSPredicate(format: "SELF MATCHES %@", name_reg)
            if name_test.evaluate(with: CommercialRecord.text) == false
            {
                valids[10] = false
                erroneousTextField()
                popUpMessage(title: "Format Error", message: "Commercial record has to be 10 digits long.")
            } else {
                self.valids[10] = true
            }
        }
        
    }
    
}
