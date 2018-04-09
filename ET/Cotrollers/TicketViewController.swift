//
//  TicketViewController.swift
//  payTest
//
//  Created by rano2 on 29/03/2018.
//  Copyright © 2018 bb. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
class TicketViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
var Event=NSDictionary()
    var index:[IndexPath]?
var dates=[String]()
var ref : DatabaseReference!
var dbHandle:DatabaseHandle?
    @IBOutlet weak var DateTable: UITableView!
    @IBOutlet weak var Eview: UIView!
    @IBOutlet weak var Ename: UILabel!
    @IBOutlet weak var AvailableTickets: UILabel!
    @IBOutlet weak var TotalPrice: UILabel!
    @IBOutlet weak var BuyButn: UIButton!
    @IBOutlet weak var reminder_btn: UIButton!
    @IBOutlet weak var Save_btn: UIButton!

    @IBOutlet var SummaryView: UIView!
    var formatter=DateFormatter()
     var formatter2=DateFormatter()
    var sdate:Date!
    var edate:Date!
    var max:Double!
    var btnColor:UIColor!
    var TicketStrings=[String]()
    var TicketID=[String]()
    var user=NSDictionary()
    var num=0
    var data=[String]()
    let calendar=Calendar.current
    override func viewDidLoad() {
        super.viewDidLoad()
        ref=Database.database().reference()
       var uid = Auth.auth().currentUser?.uid
        ref?.child("Customers/\(uid!)").observe(.value, with: { (snapshot) in
            if snapshot.exists(){
                self.user=snapshot.value as! NSDictionary
            }})
        Eview.layer.masksToBounds=true
        Eview.layer.cornerRadius=8
        Eview.center=view.center
        Eview.center.y = 353
        SummaryView.layer.masksToBounds=true
        SummaryView.layer.cornerRadius=8
        SummaryView.center=view.center
        SummaryView.center.y = 353
DateTable.delegate=self
DateTable.dataSource=self
DateTable.layer.masksToBounds=true
DateTable.layer.cornerRadius=8
DateTable.allowsMultipleSelection=true
formatter.dateStyle = .full
formatter.dateFormat="dd/MM/yyyy"
sdate=formatter.date(from:Event["SDate"] as! String)
edate=formatter.date(from:Event["EDate"]as! String)
Ename.text=Event["title"] as! String
TotalPrice.text="0 SAR"
btnColor=BuyButn.backgroundColor!
formatter2.dateFormat = "EE"
        if sdate == edate{
            self.dates.append(formatter.string(from:sdate!))
        }else{
            var start=sdate
            var end=edate

            while  start! <= end! {
                self.dates.append("\(formatter2.string(from: start!)) \(formatter.string(from: start!))")
                start = calendar.date(byAdding: .day, value: 1, to: start!)
                
            }
            
        }
        dbHandle = ref?.child("Events/\(Event["ID"]!)").observe(.value, with: { (snapshot) in
            if snapshot.exists(){
                let event=snapshot.value as! NSDictionary
             self.max=Double(event["RemainingTickets"] as! String)!
                self.DateTable.reloadData()
                self.AvailableTickets.text?=event["RemainingTickets"] as! String
                if Int(event["RemainingTickets"] as! String)! == 0{
                   self.BuyButn.isEnabled=false
                    self.BuyButn.backgroundColor=UIColor.gray
                    self.BuyButn.titleLabel?.textColor=UIColor.black
                }else{
                    self.BuyButn.isEnabled=true
                    self.BuyButn.backgroundColor=self.btnColor
                    self.BuyButn.titleLabel?.textColor=UIColor.white
                }
            }})
        UNUserNotificationCenter.current().requestAuthorization(options:[.alert,.sound]) { (success, error) in
            if error != nil {
                print("no auth")
              
            }  else{
                print("Auth")
            }
        }

    }

 //////////////Tickets Dates////////////////////////
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"cell", for: indexPath) as! DateCell
        cell.date.text=dates[indexPath.row]

        cell.stepper.maximumValue=self.max
        cell.stepper.tag=indexPath.row
        print(indexPath.row)
        return cell
        
    }

    ////////////////preventing Wrong touches///////////////////////////
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first?.view != Eview && touches.first?.view != SummaryView{self.dismiss(animated:true, completion:nil)}
    }

    /////////////////Stepper for number of tickets/////////////////////
    @IBAction func stepperPressed(_ sender: UIStepper) {
        let cell = DateTable.cellForRow(at: IndexPath.init(row:sender.tag, section:0)) as! DateCell
        cell.stepperLabel.text=String(Int(sender.value))
        
        if cell.stepperLabel.text != "0"{
            
            DateTable.selectRow(at:IndexPath.init(row:sender.tag, section:0), animated:false, scrollPosition:UITableViewScrollPosition.init(rawValue:0)!)
           
            
        }else{DateTable.deselectRow(at:IndexPath.init(row:sender.tag, section:0), animated:false)}
       
        
        self.TotalPrice.text = calculateTotalPrice()
        self.TotalPrice.text?.append(" SAR")
        
    }
    //////////////Total price calculations//////////////////
    func calculateTotalPrice()-> String{
        
        var num=0
        if DateTable.indexPathsForSelectedRows?.count != nil{
           self.index=DateTable.indexPathsForSelectedRows

        for ind in self.index!{
            if let cell=DateTable.cellForRow(at:ind) as? DateCell{
                num=num+Int(cell.stepperLabel.text!)!}
            }
        let price=Int(Event["TicketPrice"] as! String)
        let total = price! * num
                return String(total)}
            else{return "0"}
        
        
    }
    
    @IBAction func BuyPressed(_ sender: UIButton) {
        let price=self.TotalPrice.text!
        let result = price.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789").inverted)
        let int=Int(result)
        if int == 0{
            let alert = UIAlertController(title: "Select Dates", message: "You need to Select the Date(s) to purchase the ticket(s).", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel , handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }else{
            if DateTable.indexPathsForSelectedRows?.count != nil{
            self.index=DateTable.indexPathsForSelectedRows
            self.TicketID.removeAll()
            for ind in self.index!{
                var cell=DateTable.cellForRow(at:ind) as! DateCell
                if cell.stepperLabel.text != "0"{
                for x in 1...Int(cell.stepperLabel.text!)!{
                    let id=self.ref.childByAutoId().key
                    let data="\(cell.date.text!)\nEvent Name: \(Event["title"]as!String)\nUser Name: \(self.user.value(forKey:"firstname")!)\nTicket Number: \(x)\n\(id)"
                  self.TicketStrings.append(data)
                    self.TicketID.append(id)}}
                self.num=num+Int(cell.stepperLabel.text!)!
                }
            let uid = Auth.auth().currentUser?.uid
            let spid=Event["SPID"] as! String
            let eid=Event["ID"] as! String
            var i=0
            for data in self.TicketStrings{
                ref.child("Tickets").child(self.TicketID[i]).setValue(["Data":data,"UID":uid!,"SPID":spid,"EID":eid])
                i=i+1}

            let remaining=Int(Event["RemainingTickets"]as! String)! - self.num
            self.AvailableTickets.text="\(remaining)"
            ref.child("Events/\(Event["ID"]!)").child("RemainingTickets").setValue("\(remaining)")
           
                self.view.addSubview(SummaryView)}
           }
    }
    
    @IBAction func CheckPressed(_ sender: UIButton) {
        if sender.currentBackgroundImage == #imageLiteral(resourceName: "checked") {
            sender.setBackgroundImage(#imageLiteral(resourceName: "unchecked"), for:.normal)
        }else{sender.setBackgroundImage(#imageLiteral(resourceName: "checked"), for:.normal)}
        
    }
    //////////////Genrate Image to save in Camera Roll////////////
    func drawImagesAndText(Qr:UIImage,str:String)-> UIImage {
        // 1
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 700, height: 550))
        
        let img = renderer.image { ctx in
            UIColor.white.setFill()
            ctx.fill(CGRect(x:0, y: 0, width: 700, height: 550))
            // 2
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left
            
            // 3
            let attrs = [NSAttributedStringKey.font: UIFont(name: "Kohinoor Devanagari", size: 25)!, NSAttributedStringKey.paragraphStyle: paragraphStyle]
            
            // 4
            let string = "Date:\(str)"
            string.draw(with: CGRect(x: 80, y: 377, width: 448, height: 448), options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
            
            // 5
            let mouse = Qr
            var rect = CGRect(x:45, y: 32, width: 600, height: 350)
            mouse.draw(in: rect)
        
          
        }
    
        
        // 6
       return img
    }
    //////////////Generate QR ///////////////////////
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
    //////////////Save for camera////////////////

    
    @IBAction func DoneClicked(_ sender: UIButton) {
        if self.Save_btn.currentBackgroundImage == #imageLiteral(resourceName: "checked") {
            for  str in self.TicketStrings{
                let img=drawImagesAndText(Qr:  generateQRCode(from: str)!, str:str)
                let compressed=UIImagePNGRepresentation(img)
                let im=UIImage(data:compressed!)
                UIImageWriteToSavedPhotosAlbum(im!, nil, nil, nil)
            }
        }
        if self.reminder_btn.currentBackgroundImage == #imageLiteral(resourceName: "checked") {
            var date=DateComponents()
            var calender = Calendar.init(identifier:self.calendar.identifier)
            self.index=DateTable.indexPathsForSelectedRows
            for ind in self.index!{
                let cell=DateTable.cellForRow(at:ind) as! DateCell
                if cell.stepperLabel.text != "0"{
                    let string = cell.date.text?.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789/").inverted)
                    var d=self.formatter.date(from:string!)
                    var final=calender.date(byAdding: .day, value:-1, to:d!)
                    date.year=Calendar.current.component(.year, from: final!)
                    date.month=Calendar.current.component(.month, from: final!)
                    date.day=Calendar.current.component(.day, from: final!)
                    date.hour=15
                    date.minute=00
                  scheduleNotification(dateComponents:date)

                }
            }
        }
        self.dismiss(animated:true, completion:nil)
    }
    
    func scheduleNotification(dateComponents :DateComponents) {
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = "Reminder for the Event"
        content.body = "tomorrow is \(Event["title"]!) "
        content.sound = UNNotificationSound.default()
        content.badge = 1
        let request = UNNotificationRequest(identifier: "Reminder", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) {(error) in
            if let error = error {
                print("error: \(error)")
            }
        }
    }
  
}
