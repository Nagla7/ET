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
class ReviewsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,ReviewsDelegate {

    

    
    @IBOutlet weak var RV0: UIButton!
    @IBOutlet weak var RV2: UIButton!
    @IBOutlet weak var RV1: UIButton!
    
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
    //var countValue : NSDictionary!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        RV.layer.shadowColor = UIColor.black.cgColor
        RV.layer.shadowOpacity = 0.5
        RV.layer.shadowOffset = CGSize(width: -2, height: 2)
        RV.layer.shadowRadius = 5
        RV.layer.cornerRadius = 20
        ref = Database.database().reference()
        randomID = ref.childByAutoId().key
        print(EventID,"$$$$$$$$$$$$$$$$$$$$$$$$$$$$$")
        if let uid = Auth.auth().currentUser?.uid{
            self.addReview_btn.isHidden=false
            self.text2.isHidden=false
            self.reviews.getReviews(id:self.EventID!, uid:uid)
        }else{self.addReview_btn.isHidden=true
            self.text2.isHidden=true
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
        self.Reviews.reverse()
        let cell:ReviewsCell=tableView.dequeueReusableCell(withIdentifier:"cell") as! ReviewsCell
        let review=self.Reviews[indexPath.row] as! NSDictionary
        cell.review.text=review.value(forKey:"text") as? String
        cell.Uname.text=review.value(forKey:"username") as? String
        cell.ReportBtn.tag = indexPath.row
        cell.ReportBtn.addTarget(self, action: #selector(ReportButton), for: .touchUpInside)
        return cell
    }
    
    
    
    func recieveReviews(data: [String : NSDictionary],id:NSDictionary) {
        if data.count != 0{
            self.Empty_Label.isHidden=true
            self.Reviewtable.isHidden=false
        for (_,value) in data{
            for (_,v2) in value{
                self.Reviews.append(v2 as! NSDictionary)
                
            }
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
        }
    }

    
  
    
    @IBAction func add_review(_ sender: Any) {
        if let v=text2.text{
            let uid=Auth.auth().currentUser?.uid
            let v2=NSDictionary.init(objects:[v,self.user.value(forKey:"username")], forKeys:["text" as NSCopying,"username" as NSCopying])
        self.reviews.StoreReview(EventID:self.EventID!, id:uid!, data:v2)
        self.Reviews.removeAll()
       // self.Reviews.insert(v2, at:0)
       self.Reviewtable.reloadData()
            
        }
        text2.text = ""
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
            self.ref.child("ReportedReviews").child(self.randomID).setValue(["Review" : (self.ReviewAtIndex["text"] as! String) , "EventID" : self.EventID ,"ReportID" : self.randomID  , "Reason" : self.reason , "ReportedUser" : self.ReviewAtIndex["username"] ])
            
            
                                        //----------------------------------
                                }
        
        
    
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CustomersHome")
            self.present(vc!, animated: true, completion: nil)
            self.popUpMessage(title: "Thank you", message: "We received your report and we will take it into consideration")
        }
        
    
    
    func popUpMessage(title:String, message:String){
        print("pop")
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func ReportButton(_ sender: UIButton ) {
       print(sender.tag)
        ReviewAtIndex = Reviews[sender.tag]
    }
}

    


