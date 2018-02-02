//
//  CustomControl.swift
//  ET
//
//  Created by user2 on ١٤ جما١، ١٤٣٩ هـ.
//  Copyright © ١٤٣٩ هـ com.GP.ET. All rights reserved.
//

import UIKit

class CustomControl: UIControl {
    var buttons = [UIButton]()
    var selector = UIView()
    var selectedSegmentIndex = 0
@IBInspectable
    var borderWidth: CGFloat = 0{
    didSet{
        layer.borderWidth = borderWidth
    }
    }
    @IBInspectable
    var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable
    var commaSepratedButtonTitles: String = ""{
        didSet{
            updateView()
        }
}
     @IBInspectable
    var textColor : UIColor = .black{
        didSet{
            updateView()
        }
    }
    
    @IBInspectable
    var SelctorColor : UIColor = .lightGray{
        didSet{
            updateView()
        }
    }
    
    @IBInspectable
    var SelectorTextColor : UIColor = .white{
        didSet{
            updateView()
        }
    }
    @objc func SelectUserTybe( button: UIButton) {
        for(buttonIndex , btn) in buttons.enumerated(){
            btn.setTitleColor(textColor, for: .normal)
            buttons[buttonIndex].tag = buttonIndex
            if btn == button {
                selectedSegmentIndex = buttonIndex
                let selectorStartPosition = frame.width/CGFloat(buttons.count)*CGFloat(buttonIndex)
                UIView.animate(withDuration: 0.3 , animations: {
                    self.selector.frame.origin.x = selectorStartPosition})
                btn.setTitleColor(SelctorColor, for: .normal)
                btn.setTitleColor( SelectorTextColor, for: .normal)
            }
        }
        switch button.tag {
        case 0:
            print("Customer")
        case 1:
            print("Service provider")
        default:
            print("none")
        }
        sendActions(for: .valueChanged)
    }
    
    func updateView()  {
        buttons.removeAll()
        subviews.forEach{$0.removeFromSuperview()}
        let buttonTitles = commaSepratedButtonTitles.components(separatedBy: ",")
        
        for buttonTitle in buttonTitles {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0 , bottom: 0, right:30)
            button.setTitleColor(textColor, for: .normal)
            button.addTarget(self, action: #selector(SelectUserTybe(button:)), for: .touchUpInside)
            buttons.append(button)
        }
       
        buttons[0].setTitleColor(SelectorTextColor, for: .normal)
        let selectorWidth = frame.width / CGFloat(buttonTitles.count)
        print("*************************")
        print(buttonTitles.count)
        
        selector = UIView(frame: CGRect(x: 0, y: 0, width: selectorWidth, height: frame.height))
        selector.layer.cornerRadius = frame.height/2
        selector.backgroundColor = SelctorColor
        addSubview(selector)
        let sv = UIStackView(arrangedSubviews: buttons)
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .fillProportionally
        addSubview(sv)
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
         sv.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
         sv.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        sv.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        
    }
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = frame.height/2
        // Drawing code
    }
    
    

}
