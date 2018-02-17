//
//  ReviewsViewController.swift
//  ET
//
//  Created by rano2 on 03/02/2018.
//  Copyright © 2018 com.GP.ET. All rights reserved.
//

import UIKit
import FirebaseAuth
class ReviewsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,ReviewsDelegate,Userdelegate {

    

    
    @IBOutlet weak var addReview_btn: UIButton!
    @IBOutlet weak var text2: HoshiTextField!
    @IBOutlet weak var Empty_Label: UILabel!
    @IBOutlet weak var Reviewtable: UITableView!
    @IBOutlet weak var subView: UIView!
    var EventID:String?
    var reviews = Model()
    var Reviews=[NSDictionary]()
    var user=[NSDictionary]()
    override func viewDidLoad() {
        super.viewDidLoad()
            reviews.userdelegate=self
        if let uid = Auth.auth().currentUser?.uid{
            self.addReview_btn.isHidden=false
            self.text2.isHidden=false
            self.reviews.getUserInfo(id:uid)
        }else{self.addReview_btn.isHidden=true
            self.text2.isHidden=true}
        subView.layer.masksToBounds=true
        subView.layer.cornerRadius=8
        subView.center.y=350
        print(self.EventID!,"!!!@@@@@@@@@@@@@@@@@@@@@@@@@@@@!!!!!!!!!!!")
        reviews.review=self
    
        self.reviews.getReviews(id:self.EventID!)
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
        cell.review.text=review.value(forKey:"text") as! String
        cell.Uname.text=review.value(forKey:"username") as! String
        return cell
    }
    
    func recieveReviews(data: [String : NSDictionary]) {
        if data.count != 0{
            self.Empty_Label.isHidden=true
            self.Reviewtable.isHidden=false
        for (_,value) in data{
            self.Reviews.append(value)
        }
            self.Reviewtable.reloadData()}
        else{
            self.Reviewtable.isHidden=true
            self.Empty_Label.isHidden=false
        }
    }
    func recieveUser(data: [String : NSDictionary]) {
        for (_,value) in data{
            self.user.append(value)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first?.view != self.subView{
            self.dismiss(animated:true, completion:nil)
        }
    }

    @IBAction func add_review(_ sender: Any) {
       /* let uid=Auth.auth().currentUser?.uid as! String
       // let userN=self.user.removeFirst()
        let id=userN.value(forKey:"username") as! String*/
        if let v=text2.text{
            let v2=NSDictionary.init(objects:[v,"id"], forKeys:["text" as NSCopying,"username" as NSCopying])
        //print(v2.allKeys)
        self.Reviews.insert(v2, at:0)
       self.Reviewtable.reloadData()
            
        }
    }
    }

