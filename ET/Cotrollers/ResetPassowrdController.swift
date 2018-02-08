//
//  ResetPassowrdController.swift
//  ET
//
//  Created by njoool  on 07/02/2018.
//  Copyright © 2018 com.GP.ET. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ResetPassowrdController: UIViewController {
    
    @IBOutlet weak var resetView: UIView!
    @IBOutlet weak var emailTextField: HoshiTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first?.view != resetView{self.dismiss(animated:true, completion:nil)}
    }
    
    func textFieldShouldReturn(_ textfield:UITextField)->Bool{
        textfield.resignFirstResponder()
        return true
    }

    
    @IBAction func submitAction(_ sender: AnyObject) {
        
        Auth.auth().sendPasswordReset(withEmail: self.emailTextField.text!, completion: { (error) in

            var title = ""
            var message = ""
            
            if error != nil {
                title = "Error!"
                message = (error?.localizedDescription)!
            } else {
                title = "Success!"
                message = "Password reset email sent."
                print(message)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "C_SP_Login")
                self.present(vc!, animated: true, completion: nil)
            }
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
