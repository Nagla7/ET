//
//  Popup.swift
//  ET
//
//  Created by leena hassan on 16/05/1439 AH.
//  Copyright © 1439 com.GP.ET. All rights reserved.
//

import UIKit

class Popup: UIViewController {
    @IBOutlet weak var CustomerFirstName: DesignableTextField!
    
    @IBOutlet weak var ServiceCommercial: DesignableTextField!
    @IBOutlet weak var ServiceEmail: DesignableTextField!
    @IBOutlet weak var ServiceCompany: DesignableTextField!
    @IBOutlet weak var ServiceFirstname: DesignableTextField!
    @IBOutlet weak var ServicePhone: DesignableTextField!
    @IBOutlet weak var CustomerPhone: DesignableTextField!
    @IBOutlet weak var CustomerPassword: DesignableTextField!
    @IBOutlet weak var ServiceUserName: DesignableTextField!
    @IBOutlet weak var ServicePassword: DesignableTextField!
    @IBOutlet weak var ServiceRePassword: DesignableTextField!
    @IBOutlet weak var CustomerEmail: DesignableTextField!
    @IBOutlet weak var CustomerLastName: DesignableTextField!
    @IBOutlet weak var ServiceLastName: DesignableTextField!
    @IBOutlet weak var ServiceSignUp: UIButton!
    @IBOutlet weak var CustomerRePassword: DesignableTextField!
    @IBOutlet weak var CustometUserName: DesignableTextField!
    @IBOutlet weak var Male: UIButton!
    
    @IBOutlet weak var Female: UIButton!
    @IBOutlet weak var CustomerSignUp: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        ServiceFirstname.isHidden = true
        ServiceLastName.isHidden = true
        ServiceEmail.isHidden = true
        ServicePhone.isHidden = true
        ServiceUserName.isHidden = true
        ServicePassword.isHidden = true
        ServiceRePassword.isHidden = true
        ServiceCompany.isHidden=true
        ServiceCommercial.isHidden = true
        ServiceSignUp.isHidden = true
    }
    
   //dismiss button for log in
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //close button for register
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func SelectUser(_ sender: CustomControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            //customer
            CustomerFirstName.isHidden = false
            CustomerLastName.isHidden = false
            CustomerEmail.isHidden = false
            CustomerPhone.isHidden = false
            CustometUserName.isHidden = false
            CustomerPassword.isHidden = false
            CustomerRePassword.isHidden = false
            Male.isHidden=false
            Female.isHidden = false
            CustomerSignUp.isHidden = false
            //service hidden
            ServiceFirstname.isHidden = true
            ServiceLastName.isHidden = true
            ServiceEmail.isHidden = true
            ServicePhone.isHidden = true
            ServiceUserName.isHidden = true
            ServicePassword.isHidden = true
            ServiceRePassword.isHidden = true
            ServiceCompany.isHidden=true
            ServiceCommercial.isHidden = true
            ServiceSignUp.isHidden = true

       print("Customer+++333")
            
        case 1:
            //Customer hidden
            CustomerFirstName.isHidden = true
            CustomerLastName.isHidden = true
            CustomerEmail.isHidden = true
            CustomerPhone.isHidden = true
            CustometUserName.isHidden=true
            CustomerPassword.isHidden=true
            CustomerRePassword.isHidden=true
            Male.isHidden=true
            Female.isHidden=true
            CustomerSignUp.isHidden = true
            //service
            ServiceFirstname.isHidden = false
           ServiceLastName.isHidden = false
            ServiceEmail.isHidden = false
            ServicePhone.isHidden = false
            ServiceUserName.isHidden = false
           ServicePassword.isHidden = false
            ServiceRePassword.isHidden = false
            ServiceCompany.isHidden=false
            ServiceCommercial.isHidden = false
            ServiceSignUp.isHidden = false
            print("888888")
        default:
            print("none")
    }
    
    
}
}
