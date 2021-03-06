//
//  LoginViewController.swift
//  ET
//
//  Created by user2 on ١٤ جما١، ١٤٣٩ هـ.
//  Copyright © ١٤٣٩ هـ com.GP.ET. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import DLRadioButton

class LoginViewController: UIViewController , UITextFieldDelegate {

    @IBOutlet var C: DLRadioButton!  // customer button
    @IBOutlet weak var LoginView: UIView!
    @IBOutlet weak var username: HoshiTextField!
    @IBOutlet weak var password: HoshiTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username.delegate = self
        password.delegate = self
        
        LoginView.center=view.center
        LoginView.layer.masksToBounds=true
        LoginView.layer.cornerRadius=8

        // selecting button
        C.isSelected = true
        C.isHighlighted = true
        // Do any additional setup after loading the view.
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first?.view != LoginView{self.dismiss(animated:true, completion:nil)}
    }
    
    
    func textFieldShouldReturn(_ textfield:UITextField)->Bool{
        textfield.resignFirstResponder()
        return true
    }
    
    @IBAction func loginAction(_ sender: Any) {
        
       let selected = C.isSelected
        var Selected=""
        if(selected)
        {Selected = "Customers"}
        else
        {Selected = "ServiceProviders"}
        let ref : DatabaseReference!
        ref = Database.database().reference()

        if self.username.text == "" || self.password.text == "" {
            
            //Alert to tell the user that there was an error because they didn't fill anything in the textfields
            let alertController = UIAlertController(title: "Error", message: "Please enter an username and password.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            //check which user tree and redirect page
            var tree = Selected // or "ServiceProviders"
            var page = Selected+"Home" // or "ServiceProviderHome"
            
            // search database for the username ---> get the corresponding email
            ref.child(tree).queryOrdered(byChild: "username").queryEqual(toValue: self.username.text!.lowercased()).observeSingleEvent(of: .value , with: { snapshot in
                if snapshot.exists() {
                    
                    //getting the email to login
                    var email = ""
                    let data = snapshot.value as! [String: Any]
                    for (_,value) in data {
                        let user = value as? NSDictionary
                        email = user!["email"] as! String
                    }
                    
                    // login with email and password from firebase
                    Auth.auth().signIn(withEmail: email, password: self.password.text!) { (user, error) in
                        if error == nil {
                            
                            //Go to the HomeViewController if the login is sucessful
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: page)
                            self.present(vc!, animated: true, completion: nil)
                            
                        } else {
                            //Tells the user that there is an error and then gets firebase to tell them the error
                            let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alertController.addAction(defaultAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                } else {
                    //error message: username already exists
                    let alertController = UIAlertController(title: "Uh oh!", message: "Wrong username or password.", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        }
    }

}
