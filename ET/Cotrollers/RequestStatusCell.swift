//
//  RequestStatusCell.swift
//  ET
//
//  Created by rano2 on 16/04/2018.
//  Copyright © 2018 com.GP.ET. All rights reserved.
//

import UIKit

class RequestStatusCell: UITableViewCell {

    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var status: UILabel!
    func SetStatus(){
        status.layer.masksToBounds=true
        status.layer.cornerRadius=8
    }
    
}
