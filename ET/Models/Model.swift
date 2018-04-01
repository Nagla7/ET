//
//  Event.swift
//  ET
//
//  Created by rano2 on 09/02/2018.
//  Copyright © 2018 com.GP.ET. All rights reserved.
//

import UIKit
import Firebase
protocol EventDelegate:class {
    func recieveEvents(data:[String:NSDictionary])
}
protocol VenueDelegate:class{
    func recieveVenues(data:[String:NSDictionary])
}
protocol ReviewsDelegate:class {
    func recieveReviews(data:[String:NSDictionary],id:NSDictionary)
}
protocol RatingDelegate:class {
    func recieveRating(data:[String:NSDictionary])
}
class Model{
    var ref : DatabaseReference!
    var dbHandle:DatabaseHandle?
     var delegate: EventDelegate?
    var Venuedelegate:VenueDelegate?
    var review:ReviewsDelegate?
    var RateDelegate:RatingDelegate?
    ////////Events connection /////////////
    func getEvents() {
        ref=Database.database().reference()
        dbHandle = ref?.child("Events").observe(.value, with: { (snapshot) in
            if snapshot.exists(){
                let v=snapshot.value as! [String:NSDictionary]
                self.delegate?.recieveEvents(data:v)}
            else{self.delegate?.recieveEvents(data:[String:NSDictionary]())}
        })}
    //////////Venues connection////////////////////
    func getVenues(){
        ref=Database.database().reference()
        dbHandle = ref?.child("Venues").observe(.value, with: { (snapshot) in
            if snapshot.exists(){
            let v=snapshot.value as? [String:NSDictionary]
                self.Venuedelegate?.recieveVenues(data:v!)}
            else{self.Venuedelegate?.recieveVenues(data:[String:NSDictionary]())}
        })
    }
    ///////////Reviews Connection////////////////
    func getReviews(id:String,uid:String){
        ref=Database.database().reference()
        var user=NSDictionary()
        dbHandle = ref?.child("Customers/\(uid)").observe(.value, with: { (snapshot) in
            if snapshot.exists(){
                user=snapshot.value as! NSDictionary
            }})
        dbHandle = ref?.child("Reviews/\(id)").observe(.value, with: { (snapshot) in
            if snapshot.exists(){
                let v=snapshot.value as! [String:NSDictionary]
                self.review?.recieveReviews(data:v, id:user)
            }
            else{self.review?.recieveReviews(data:[String:NSDictionary](), id:user)}
        })}
        
    


    /////////////Rate connection///////////
    func getRatings(){
        ref=Database.database().reference()
        dbHandle = ref?.child("Rate").observe(.value, with: { (snapshot) in
            if snapshot.exists(){
                let v=snapshot.value as! [String:NSDictionary]
                self.RateDelegate?.recieveRating(data:v)}
            else{
                self.RateDelegate?.recieveRating(data:[String:NSDictionary]())}
        })
    }
    ///////////////////////connection for storing/////////////
   
    func StoreRate(tag:Int,EventId:String,Uid:String){
        ref=Database.database().reference()
        print(tag,"%%%%%%%%%%%tag")
        print(EventId,"%%%%%%%%%%%%%%%%%%%%")
        print(Uid,"£$£$^^^^^^^")
       ref?.child("Rate/\(EventId)/\(Uid)").setValue(["rate":tag])
    }
}
