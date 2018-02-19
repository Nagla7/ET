//
//  EventInfoController.swift
//  ET
//
//  Created by rano2 on 02/02/2018.
//  Copyright © 2018 com.GP.ET. All rights reserved.
//

import UIKit
import FirebaseAuth
class EventInfoController: UIViewController {


    @IBOutlet weak var purchase: UIButton!
    @IBOutlet var Time_date: UILabel!
    @IBOutlet var location: UILabel!
    @IBOutlet var information: UITextView!
    @IBOutlet weak var RootView: UIView!
    @IBOutlet weak var Eview: UIView!
    @IBOutlet var stars: [UIButton]!
    var Event=NSDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
        if let uid=Auth.auth().currentUser?.uid as? String{
            for str in stars{str.isHidden=false}
        }else{for str in stars{str.isHidden=true}}
        Eview.layer.masksToBounds=true
        Eview.layer.cornerRadius=8
        Eview.center.y = 353
       // Eview.center=view.center
        self.information.text=self.Event["Description"] as! String
        self.location.text=self.Event["City"] as! String
        self.Time_date.text=self.Event["Date"] as! String
        self.Time_date.text?.append(" \(self.Event["Time"]!)")
        
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
            destination.EventID=self.Event.value(forKey:"ID") as! String}
    }
    ///////////rate event///////////
    
    @IBAction func RateEvent(_ sender: UIButton) {
        var rate=sender.tag
        
        for star in self.stars {
            if star.tag<=rate{
                star .setTitle("★", for: UIControlState.normal )}
            else{star .setTitle("☆", for: UIControlState.normal )}
            
        }
    }

    @IBAction func OpenMap(_ sender: Any) {
        performSegue(withIdentifier:"map", sender: EventCell())
    }

}
