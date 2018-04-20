//
//  VenueCell.swift
//  ET
//
//  Created by rano2 on 19/02/2018.
//  Copyright © 2018 com.GP.ET. All rights reserved.
//

import UIKit

class VenueCell: UITableViewCell {
    @IBOutlet weak var Vimage: UIImageView!
    @IBOutlet weak var Vname: UILabel!
    @IBOutlet weak var Vcapacity: UILabel!
    @IBOutlet weak var Vphone: UILabel!
    @IBOutlet weak var Vcost: UILabel!
    @IBOutlet weak var Vemail: UILabel!
    @IBOutlet weak var link_btn: UIButton!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var city: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
