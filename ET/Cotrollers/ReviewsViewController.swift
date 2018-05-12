//
//  ReviewsViewController.swift
//  ET
//
//  Created by rano2 on 03/02/2018.
//  Copyright © 2018 com.GP.ET. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import Alamofire
class ReviewsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,ReviewsDelegate {

    

    
    @IBOutlet weak var RV0: UIButton!
    @IBOutlet weak var RV2: UIButton!
    @IBOutlet weak var RV1: UIButton!
    @IBOutlet weak var block: UILabel!
    @IBOutlet var ReportReviewView: UIView!
    @IBOutlet weak var addReview_btn: UIButton!
    @IBOutlet weak var text2: HoshiTextField!
    @IBOutlet weak var Empty_Label: UILabel!
    @IBOutlet weak var Reviewtable: UITableView!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var RV: UIView!
    var ref : DatabaseReference!
    var dbHandle : DatabaseHandle!
    var Check : [Bool] = [false,false,false]
    var EventID:String?
    var reviews = Model()
    var Reviews=[NSDictionary]()
    var user = NSDictionary()
    var ReportedUser : NSDictionary!
    var ReviewAtIndex : NSDictionary!
    var randomID : String = ""
    var reason : String?
    var adminToken:String?
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        RV.layer.shadowColor = UIColor.black.cgColor
        RV.layer.shadowOpacity = 0.5
        RV.layer.shadowOffset = CGSize(width: -2, height: 2)
        RV.layer.shadowRadius = 5
        RV.layer.cornerRadius = 20
        ref = Database.database().reference()
        ref.child("Users").queryOrdered(byChild:"type").queryEqual(toValue:"admin").observe(.value, with:{(snapshot) in
            if snapshot.exists(){
                var value = snapshot.value as! NSDictionary
                for (_,v) in value{
                    var data=v as! NSDictionary
                    self.adminToken=data.value(forKey:"token") as? String
                }
            }
        })
        
        self.block.isHidden = true
     


        if let uid = Auth.auth().currentUser?.uid{
             var blocked = String()
            self.addReview_btn.isHidden=false
            self.text2.isHidden=false
            ref.child("Customers").child(uid).observe(.value, with: { (snapshot) in
                if snapshot.exists(){
                   
                    let data = snapshot.value as! [String: Any]
                    blocked = data["blocked"] as! String
                    
                    if(blocked == "true"){
                    self.text2.isHidden = true;
                    self.addReview_btn.isEnabled = false
                    self.block.isHidden = false}
                
                else{
                    self.block.isHidden = true
                    self.addReview_btn.isEnabled = true
                    }}
                self.Reviewtable.frame=CGRect.init(x:0, y:144, width:325, height:346)
            })
            self.reviews.getReviews(id:self.EventID!, uid:uid)
        }else{
            self.addReview_btn.isHidden=true
            self.text2.isHidden=true
            self.Reviewtable.frame=CGRect.init(x:0, y:59, width:325, height:429)
            self.reviews.getReviews(id:self.EventID!, uid:"")
        }
        subView.layer.masksToBounds=true
        subView.layer.cornerRadius=8
        subView.center.y=350
        reviews.review=self
    }

    @IBAction func backButtoPressed(_ sender: UIButton) {
        self.dismiss(animated:true, completion:nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.Reviews.count != 0{
            self.Empty_Label.isHidden=true
            self.Reviewtable.isHidden=false
        }
        else{
            self.Empty_Label.isHidden=false
            self.Reviewtable.isHidden=true
        }
        return self.Reviews.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ReviewsCell=tableView.dequeueReusableCell(withIdentifier:"cell") as! ReviewsCell
        let review=self.Reviews[indexPath.row] as! NSDictionary
        cell.review.text=review.value(forKey:"text") as? String
        cell.Uname.text=review.value(forKey:"username") as? String
        if let uid = Auth.auth().currentUser?.uid{
        cell.ReportBtn.tag = indexPath.row
            cell.ReportBtn.addTarget(self, action: #selector(ReportButton), for: .touchUpInside)
            cell.ReportBtn.isHidden=false
        }else{cell.ReportBtn.isHidden=true}
        return cell
    }
    
    
    
    func recieveReviews(data: [String : NSDictionary],id:NSDictionary) {
        if data.count != 0{
            self.Empty_Label.isHidden=true
            self.Reviewtable.isHidden=false
        for (_,value) in data{
            
                self.Reviews.append(value as! NSDictionary)
                
            
        }
            self.Reviewtable.reloadData()}
        else{
            self.Reviewtable.isHidden=true
            self.Empty_Label.isHidden=false
        }
    self.user=id
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first?.view != self.subView{
            self.dismiss(animated:true, completion:nil)
        }else if touches.first?.view != self.ReportReviewView{
            self.dismiss(animated:true, completion:nil)
        }
    }

    
  
    
    @IBAction func add_review(_ sender: Any) {
        if(text2.text != ""){
        if let v=text2.text{
            let uid=Auth.auth().currentUser?.uid
             let autoid = ref.childByAutoId().key
            let v2=NSDictionary.init(objects:[v,self.user.value(forKey:"username"),autoid],forKeys:["text" as NSCopying,"username" as NSCopying,"AutoID" as NSCopying])
            
            ref.child("Reviews/\(EventID!)").child(autoid).setValue(v2)
            
        self.Reviews.removeAll()
       self.Reviewtable.reloadData()
            
        }
            text2.text = ""}
        else{
             self.popUpMessage(title: "Error", message: "Please enter a comment first")
        }
    }
    //------------ Report Review ----------------------
    @IBAction func ShowReportV(_ sender: UIButton) {
        self.view.addSubview(ReportReviewView)
        ReportReviewView.center = self.view.center
    }
    
   @IBAction func SelectReason (_ sender: UIButton){
        let Btag = sender.tag
        switch Btag {
        case 0:
            Check[Btag] = true
            Check[1] = false
            Check[2] = false
            reason = "Unwanted commercial content or spam"
            //background
            sender.backgroundColor = UIColor(displayP3Red: 75/255, green: 160/255, blue: 158/255, alpha: 1.0)
            RV1.backgroundColor = UIColor(displayP3Red: 251/255, green: 251/255, blue: 251/255, alpha: 1.0)
            RV2.backgroundColor = UIColor(displayP3Red: 251/255, green: 251/255, blue: 251/255, alpha: 1.0)
            //title color
            sender.setTitleColor(UIColor.white, for: .normal)
            RV1.setTitleColor(UIColor(displayP3Red: 31/255, green: 189/255, blue: 188/255, alpha: 1.0) , for: .normal)
            RV2.setTitleColor(UIColor(displayP3Red: 31/255, green: 189/255, blue: 188/255, alpha: 1.0) , for: .normal)
         
            
        case 1:
            Check[Btag] = true
            Check[0] = false
            Check[2] = false
            reason = "Harassment or bullying"
            //background
            sender.backgroundColor = UIColor(displayP3Red: 75/255, green: 160/255, blue: 158/255, alpha: 1.0)
            RV0.backgroundColor = UIColor(displayP3Red: 251/255, green: 251/255, blue: 251/255, alpha: 1.0)
            RV2.backgroundColor = UIColor(displayP3Red: 251/255, green: 251/255, blue: 251/255, alpha: 1.0)
          
           
            //title color
            sender.setTitleColor(UIColor.white, for: .normal)
            RV0.setTitleColor(UIColor(displayP3Red: 31/255, green: 189/255, blue: 188/255, alpha: 1.0) , for: .normal)
            RV2.setTitleColor(UIColor(displayP3Red: 31/255, green: 189/255, blue: 188/255, alpha: 1.0) , for: .normal)
            
        case 2:
            Check[Btag] = true
            Check[1] = false
            Check[0] = false
            reason = "Hate speech or graphic violence"
            //background
            sender.backgroundColor = UIColor(displayP3Red: 75/255, green: 160/255, blue: 158/255, alpha: 1.0)
            RV1.backgroundColor = UIColor(displayP3Red: 251/255, green: 251/255, blue: 251/255, alpha: 1.0)
            RV0.backgroundColor = UIColor(displayP3Red: 251/255, green: 251/255, blue: 251/255, alpha: 1.0)
    
           
            //title color
            sender.setTitleColor(UIColor.white, for: .normal)
            RV1.setTitleColor(UIColor(displayP3Red: 31/255, green: 189/255, blue: 188/255, alpha: 1.0) , for: .normal)
            RV0.setTitleColor(UIColor(displayP3Red: 31/255, green: 189/255, blue: 188/255, alpha: 1.0) , for: .normal)
           
       
        default:
            print("default")}

            
        }
    
    
   
    @IBAction func ReportAction(_ sender: UIButton) {
        
           randomID = ref.childByAutoId().key
        //________________________________________________________
        var count = "0";
        var flag =  Bool()
        flag = Check[0] || Check[1] || Check[2]
        if !flag {
            let alertController = UIAlertController(title: "Error", message: "The reason is required. Please choose one of the available reasons", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            
        }
        else{
    
        
           
         
                                    //------- ADD REPOET TO DATABASE---------
            self.ref.child("ReportedReviews").child(self.randomID).setValue(["Review" : (self.ReviewAtIndex["text"] as! String) , "EventID" : self.EventID ,"ReportID" : self.randomID  , "Reason" : self.reason , "ReportedUser" : self.ReviewAtIndex["username"] , "ReviewId" :(self.ReviewAtIndex["AutoID"] as! String) ])
            
            self.sendNotification()
                                        //----------------------------------
                                }
            self.popUpMessage(title: "Thank you", message: "We received your report and we will take it into consideration")
        ReportReviewView.removeFromSuperview()
        }
        
    
    
    func popUpMessage(title:String, message:String){
        print("pop")
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func ReportButton(_ sender: UIButton ) {
        ReviewAtIndex = Reviews[sender.tag]
    }
    
    
    func sendNotification(){
        let title = "Reported Comment"
        let body = "a customer reported a comment "
        
        var headers:HTTPHeaders = HTTPHeaders()
        
        headers = ["Content-Type":"application/json","Authorization":"key=\(AppDelegate.SERVERKEY)"
            
        ]
        let notification = ["to":"\(self.adminToken!)","notification":["body":body,"title":title,"badge":0,"sound":"default"]] as [String:Any]
        
        Alamofire.request(AppDelegate.NOTIFICATION_URL as URLConvertible, method: .post as HTTPMethod, parameters: notification, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print(response)
        }
    }
}

    


