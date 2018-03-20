//
//  EventInfoController.swift
//  ET
//
//  Created by rano2 on 02/02/2018.
//  Copyright © 2018 com.GP.ET. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
class EventInfoController: UIViewController {
    @IBOutlet weak var ComplaintDescription: MultilineTextField!
    @IBOutlet weak var fileComplaint: UIButton!
    @IBOutlet weak var CV: UIView!
    @IBOutlet var ComplaintView: UIView!
    @IBOutlet weak var Category_label: UILabel!
    @IBOutlet weak var purchase: UIButton!
    @IBOutlet var Time_date: UILabel!
    @IBOutlet var location: UILabel!
    @IBOutlet var information: UITextView!
    @IBOutlet weak var RootView: UIView!
    @IBOutlet weak var Eview: UIView!
    @IBOutlet var stars: [UIButton]!
    @IBOutlet weak var UserRating: UILabel!
    @IBOutlet weak var ComplaintEvent: UILabel!
    var user : NSDictionary!
     var randomID : String = ""
    
    var ref : DatabaseReference!
    var dbHandle:DatabaseHandle?
    var Event=NSDictionary()
    
    var Rate=Int()
    var model=Model()
    override func viewDidLoad() {
        super.viewDidLoad()
       fileComplaint.isHidden = true
ref = Database.database().reference()
 randomID = ref.childByAutoId().key
        CV.layer.shadowColor = UIColor.black.cgColor
        CV.layer.shadowOpacity = 0.5
        CV.layer.shadowOffset = CGSize(width: -2, height: 2)
        CV.layer.shadowRadius = 5
        CV.layer.cornerRadius = 20
        
        ComplaintDescription.layer.cornerRadius = 20
        
        //_______ Get current user info_______________
        if let uid = Auth.auth().currentUser?.uid {
            dbHandle = ref.child("Customers").child(uid).observe(.value, with: { (snapshot) in
                if snapshot.exists(){
                    self.user = snapshot.value as! NSDictionary
                    
                    }
                else {
                    print("error")
                }
            })}
        
        //______________________________________________
        
        print(Rate,"^%^%^%^%^%^%^%^%^^%^%^%^^^%^%^%")
        if let uid=Auth.auth().currentUser?.uid as? String{
            UserRating.isHidden=false
            fileComplaint.isHidden = false
            for str in stars{str.isHidden=false
                for var i in 0..<Rate {
                    stars[i] .setTitle("★", for: UIControlState.normal )}
            }
        }else{UserRating.isHidden=true
            for str in stars{str.isHidden=true}}
        Eview.layer.masksToBounds=true
        Eview.layer.cornerRadius=8
        Eview.center.y = 353
       // Eview.center=view.center
        self.information.text=self.Event["Description"] as! String
        self.location.text=self.Event["City"] as! String
        self.Time_date.text=self.Event["Date"] as! String
        self.Time_date.text?.append(" \(self.Event["Time"]!)")
        self.Category_label.text?=self.Event["Category"]as!String
        self.Category_label.text?.append(" - \(self.Event["Target Audience"]as! String)")
      self.ComplaintEvent.text? = self.Event["title"]as! String
        
    }
///////////////touching for dismiss//////////////////////////////////////
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first?.view != Eview {self.dismiss(animated:true, completion:nil)}
    }
    /////////////clicking the review///////////////////
    @IBAction func review(_ sender: UIButton) {
performSegue(withIdentifier:"review", sender:AnyClass.self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "map"){
            let destination=segue.destination as! MapViewController
            destination.Event=self.Event}
        
        if segue.identifier=="review"{
        let destination=segue.destination as! ReviewsViewController
            destination.EventID=self.Event["ID"] as! String}
    }
    ///////////rate event///////////
    
    @IBAction func RateEvent(_ sender: UIButton) {
        var rate=sender.tag
        
        for star in self.stars {
            if star.tag<=rate{
                star .setTitle("★", for: UIControlState.normal )}
            else{star .setTitle("☆", for: UIControlState.normal )}
            
        }
        model.StoreRate(tag:rate, EventId:Event.value(forKey:"ID") as! String, Uid:(Auth.auth().currentUser?.uid)!)
        
    }

    @IBAction func OpenMap(_ sender: Any) {
        performSegue(withIdentifier:"map", sender: EventCell())
    }

    @IBAction func ShowComplaintView(_ sender: Any) {
        self.view.addSubview(ComplaintView)
       ComplaintView.center = self.view.center
        
    }
    
  
    @IBAction func ComplaintAction(_ sender: UIButton) {
         var flag =  Bool()
        flag = self.ComplaintDescription.text == ""
        if flag {
            let alertController = UIAlertController(title: "Error", message: "The complatint discription is required. Please enter it", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)}
            
        else{
            ref.child("Complaint").child(self.randomID).setValue(["EventName": ComplaintEvent.text! , "CID": randomID , "Discription" : ComplaintDescription.text! , "CustomerId" : user["UID"] as! String , "CustomerEmail" : user["email"] as! String , "CustomerPhoneNum" : user["phonenumber"] as! String , "EventId" : Event["ID"]as! String , "status" : "In progress"])
          //----------- ERROR --------------
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Main")
            self.present(vc!, animated: true, completion: nil)
            let alert = UIAlertController(title: "Thank you", message: "We received your complaint and we will take it into consideration", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel , handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        
        }
    }
    
}
