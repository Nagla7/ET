//
//  EventInfoController.swift
//  ET
//
//  Created by rano2 on 02/02/2018.
//  Copyright © 2018 com.GP.ET. All rights reserved.
//

import UIKit

class EventInfoController: UIViewController {

    @IBOutlet weak var RootView: UIView!
    @IBOutlet weak var Eview: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        Eview.layer.masksToBounds=true
        Eview.layer.cornerRadius=8
        Eview.center=view.center
    }
    @IBAction func Tab(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated:true,
                                completion:nil)
    }
}
