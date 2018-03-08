//
//  IssueReqViewController.swift
//  ET
//
//  Created by Wejdan Aziz on 04/03/2018.
//  Copyright © 2018 com.GP.ET. All rights reserved.
//

import UIKit

class IssueReqViewController: UIViewController , UIScrollViewDelegate , UITextFieldDelegate{
    @IBOutlet weak var PhoneNumber: HoshiTextField!
    @IBOutlet weak var ERules: UITextView!
    @IBOutlet weak var Email: HoshiTextField!
    @IBOutlet weak var Name: HoshiTextField!
    var PI = Int()
    @IBOutlet weak var Pages: UIPageControl!
    @IBOutlet weak var Cost: HoshiTextField!
    @IBOutlet weak var Earnings: HoshiTextField!
    @IBOutlet weak var EventImg: UIImageView!
    @IBOutlet weak var FirstView: UIView!
    @IBOutlet weak var EventDiscription: UITextView!
    @IBOutlet weak var ScrollVIew: UIScrollView!
    @IBOutlet weak var SDate : UITextField!
    
    @IBOutlet weak var LocationCapacity: HoshiTextField!
    @IBOutlet weak var City: HoshiTextField!
    @IBOutlet weak var CTime: HoshiTextField!
    @IBOutlet weak var OTime: HoshiTextField!
    @IBOutlet weak var EDate: HoshiTextField!
    @IBOutlet weak var EventName: HoshiTextField!
    var Dpicker = UIDatePicker()
    var Dpicker2 = UIDatePicker()
    var Tpicker = UIDatePicker()
    var Tpicker2 = UIDatePicker()
    var xOffset = CGFloat()
    var yOffset = CGFloat()
    override func viewDidLoad() {
        super.viewDidLoad()
        createdatepicker()
       /* NotificationCenter.default.addObserver(self, selector: #selector(iewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)*/

   //     let notificationCenter = NotificationCenter.default
     //   notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
     //   notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

        // Do any additional setup after loading the view

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()

        self.ScrollVIew.delegate = self
       
        // Dispose of any resources that can be recreated.
    }
    
   @IBAction func ChangePage(_ sender: UIPageControl) {
        switch sender.currentPage {
        case 0:
            ScrollVIew?.setContentOffset(CGPoint(x:0 , y: 0), animated: true)
        case 1:
            print(sender.currentPage)
            ScrollVIew?.setContentOffset(CGPoint(x:375 , y: 0), animated: true)
        default:
            print("Defult")
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        xOffset = scrollView.contentOffset.x;
        yOffset = scrollView.contentOffset.y;
        switch xOffset {
        case 0:
            self.Pages.currentPage = 0
        case 375:
            self.Pages.currentPage = 1
        default:
            self.Pages.currentPage = 0
        }
    }
    //-----Date picker--------
    func createdatepicker() {
        
        Dpicker.datePickerMode = .date
        Dpicker2.datePickerMode = .date
        Tpicker2.datePickerMode = .time
        Tpicker.datePickerMode = .time
        let tollbar = UIToolbar()
        tollbar.sizeToFit()
        
        let tollbar2 = UIToolbar()
        tollbar2.sizeToFit()
        
        let toolbar3 = UIToolbar()
        toolbar3.sizeToFit()
        
        let toolbar4 = UIToolbar()
        toolbar4.sizeToFit()
        
        
        let donebutton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done1))
        let donebutton2 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done2))
        let donebutton3 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done3))
        let donebutton4 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done4))
        tollbar.setItems([donebutton], animated: true)
        SDate.inputAccessoryView = tollbar
         tollbar2.setItems([donebutton2], animated: true)
        EDate.inputAccessoryView = tollbar2
        SDate.inputView = Dpicker
        EDate.inputView = Dpicker2
        
       toolbar3.setItems([donebutton3], animated: true)
       OTime.inputAccessoryView = toolbar3
        OTime.inputView = Tpicker
        toolbar4.setItems([donebutton4], animated: true)
        CTime.inputAccessoryView = toolbar4
        CTime.inputView = Tpicker2
        
        
        
    }
   
  //----------Done Datepickers ---------------
  
    @objc func done1() {
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .short
        let date = dateformatter.string(from: Dpicker.date)
        SDate.text = date
        self.view.endEditing(true)
    }
     @objc func done2() {
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .short
        let date2 = dateformatter.string(from: Dpicker2.date)
        EDate.text = date2
        self.view.endEditing(true)
    }
    @objc func done3() {
        let calendar = Calendar.current
       
        let minutes = calendar.component(.minute, from: Tpicker.date)
        
        var hour = calendar.component(.hour, from: Tpicker.date)
        if hour > 12 {
            hour = hour - 12
            let hourPM = "\(hour):\(minutes)PM"
              OTime.text = hourPM
        }
        if hour == 0 {
            hour = 12
            let hourAM = "\(hour):\(minutes)AM"
            OTime.text = hourAM
        }
        else {
            let hourAM = "\(hour):\(minutes)AM"
            OTime.text = hourAM
        }
        
        
        
        self.view.endEditing(true)
    }
    
    @objc func done4() {
        let calendar = Calendar.current
        var hour = calendar.component(.hour, from: Tpicker2.date)
        let minutes = calendar.component(.minute, from: Tpicker2.date)
        if hour > 12 {
            hour = hour - 12
            let hourPM = "\(hour):\(minutes)PM"
            CTime.text = hourPM
        }
        if hour == 0 {
            hour = 12
            let hourAM = "\(hour):\(minutes)AM"
            CTime.text = hourAM
        }
        else {
            let hourAM = "\(hour):\(minutes)AM"
            CTime.text = hourAM
        }
        self.view.endEditing(true)
    }
//--------------------------------------------------------------
    func textFieldDidBeginEditing(_ textField: UITextField) {
            moveTextField(textField, moveDistance: -250, up: true)
    }
    
    // Finish Editing The Text Field
    func textFieldDidEndEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -250, up: false)
    }
    
    // Hide the keyboard when the return key pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Move the text field in a pretty animation!
    func moveTextField(_ textField: UITextField, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
  /*  @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == Notification.Name.UIKeyboardWillHide {
           
        .contentInset = UIEdgeInsets.zero
        } else {
            yourTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        yourTextView.scrollIndicatorInsets = yourTextView.contentInset
        
        let selectedRange = yourTextView.selectedRange
        yourTextView.scrollRangeToVisible(selectedRange)
    }*/
    
   /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
