//
//  DateCell.swift
//  ET
//
//  Created by rano2 on 30/03/2018.
//  Copyright © 2018 com.GP.ET. All rights reserved.
//

import UIKit

class DateCell: UITableViewCell {

    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var stepperLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
