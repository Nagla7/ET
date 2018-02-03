//
//  Popup.swift
//  ET
//
//  Created by leena hassan on 16/05/1439 AH.
//  Copyright © 1439 com.GP.ET. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var SignUpbtn: UIButton!
    @IBOutlet weak var RegisterView: UIView!
    @IBOutlet weak var companyName: HoshiTextField!
    @IBOutlet weak var CommercialRecord: HoshiTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        SignUpbtn.frame.origin.y=462
        RegisterView.frame.origin.y=100
        RegisterView.frame.origin.x=16; RegisterView.frame.size=CGSize.init(width:347, height:512)
        RegisterView.layer.masksToBounds=true
        RegisterView.layer.cornerRadius=8
        

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
}
