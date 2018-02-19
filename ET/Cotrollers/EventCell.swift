//
//  EventCell.swift
//  ET
//
//  Created by rano2 on 31/01/2018.
//  Copyright © 2018 com.GP.ET. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {
    @IBOutlet weak var E_image: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet var Stars: [UIButton]!
    var index=Int()
    func setRate(rate:Int){
        for var i in 0..<rate {
        self.Stars[i] .setTitle("★", for: UIControlState.normal )}}
    
    }

