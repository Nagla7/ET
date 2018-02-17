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
class Event{
    var ref : DatabaseReference!
    var dbHandle:DatabaseHandle?
     var delegate: EventDelegate?
    func getEvents() {
        ref=Database.database().reference()
        dbHandle = ref?.child("Events").observe(.value, with: { (snapshot) in
            let v=snapshot.value as! [String:NSDictionary]
            self.delegate?.recieveEvents(data:v)
        })
        
    }
}
