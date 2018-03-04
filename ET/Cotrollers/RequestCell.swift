//
//  RequestCell.swift
//  ET
//
//  Created by rano2 on 03/03/2018.
//  Copyright © 2018 com.GP.ET. All rights reserved.
//

import UIKit

class RequestCell: UICollectionViewCell {
    var id=Int()
    
    func text(frame:CGRect)->UIView{

        let view=UIView.init(frame:frame)
        view.backgroundColor=UIColor.purple
        let l=CGRect.init(x:4, y: 90, width: 300, height:100)
        let t=CGRect.init(x:4, y: 7, width: 100, height:100)
        let label1=UILabel.init(frame:l)
        let text1=UITextField.init(frame:t)
        text1.backgroundColor=UIColor.blue
        label1.text="HEEEEEEEEELLLLLLO"
        label1.textColor=UIColor.red
        view.addSubview(label1)
        view.addSubview(text1)
        return view
    }
}
