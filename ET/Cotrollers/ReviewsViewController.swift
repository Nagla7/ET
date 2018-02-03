//
//  ReviewsViewController.swift
//  ET
//
//  Created by rano2 on 03/02/2018.
//  Copyright © 2018 com.GP.ET. All rights reserved.
//

import UIKit

class ReviewsViewController: UIViewController {

    @IBOutlet weak var subView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        subView.layer.masksToBounds=true
        subView.layer.cornerRadius=8
        subView.center=view.center
    }

    @IBAction func backButtoPressed(_ sender: UIButton) {
        self.dismiss(animated:true, completion:nil)
    }
}
