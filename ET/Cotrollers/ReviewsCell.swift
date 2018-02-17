//
//  ReviewsCell.swift
//  ET
//
//  Created by rano2 on 16/02/2018.
//  Copyright © 2018 com.GP.ET. All rights reserved.
//

import UIKit

class ReviewsCell: UITableViewCell {
    
    
    @IBOutlet weak var Uname: UILabel!
    @IBOutlet weak var review: UITextView!
    @IBAction func reported(_ sender: UIButton) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
