//
//  EventInfoController.swift
//  ET
//
//  Created by rano2 on 02/02/2018.
//  Copyright © 2018 com.GP.ET. All rights reserved.
//

import UIKit

class EventInfoController: UIViewController {

    @IBOutlet var Time_date: UILabel!
    @IBOutlet var location: UILabel!
    @IBOutlet var information: UILabel!
    @IBOutlet weak var RootView: UIView!
    @IBOutlet weak var Eview: UIView!
    var Event=NSDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
        Eview.layer.masksToBounds=true
        Eview.layer.cornerRadius=8
        Eview.center.y = 370
        
       // Eview.center=view.center
        self.information.text=self.Event["Description"] as! String
        self.location.text=self.Event["City"] as! String
        self.Time_date.text=self.Event["Date"] as! String
        
    }
    @IBAction func Tab(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated:true,
                                completion:nil)
    }
}
