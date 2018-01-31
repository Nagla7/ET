//
//  RegisterViewController.swift
//  ET
//
//  Created by user2 on ١٤ جما١، ١٤٣٩ هـ.
//  Copyright © ١٤٣٩ هـ com.GP.ET. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var Scroll: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func SelectUserTybe(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            Scroll.setContentOffset(CGPoint(x:0 , y:0), animated: true)
        case 1:
            Scroll.setContentOffset(CGPoint(x:375 , y:0), animated: true)
        default:
        print("none")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
