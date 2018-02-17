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
    func recieveReviews(data:[String:NSDictionary])
}
protocol Userdelegate:class {
    func recieveUser(data:[String:NSDictionary])
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
    var userdelegate:Userdelegate?
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
            let v=snapshot.value as! [String:NSDictionary]
                self.Venuedelegate?.recieveVenues(data:v)}
            else{self.Venuedelegate?.recieveVenues(data:[String:NSDictionary]())}
        })
    }
    ///////////Reviews Connection////////////////
    func getReviews(id:String){
        ref=Database.database().reference()
        dbHandle = ref?.child("Reviews/\(id)").observe(.value, with: { (snapshot) in
            if snapshot.exists(){
            let v=snapshot.value as! [String:NSDictionary]
                self.review?.recieveReviews(data:v)}
            else{
                self.review?.recieveReviews(data:[String:NSDictionary]())}
        })}
    ///////////user connection/////////////
    func getUserInfo(id:String){
        ref=Database.database().reference()
        dbHandle = ref?.child("Users/\(id)").observe(.value, with: { (snapshot) in
            if snapshot.exists(){
                let v=snapshot.value as! [String:NSDictionary]
                self.userdelegate?.recieveUser(data:v)
            }})}
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
}
