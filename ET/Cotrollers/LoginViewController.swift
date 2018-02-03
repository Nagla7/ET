//
//  LoginViewController.swift
//  ET
//
//  Created by user2 on ١٤ جما١، ١٤٣٩ هـ.
//  Copyright © ١٤٣٩ هـ com.GP.ET. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var LoginView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
LoginView.center=view.center
LoginView.layer.masksToBounds=true
LoginView.layer.cornerRadius=8
        // Do any additional setup after loading the view.
    }

    @IBAction func SelectUserTybe(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("Customer")
        case 1:
            print("Service Provider")
        default:
            print("none")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated:true, completion:nil)
    }
    

}
