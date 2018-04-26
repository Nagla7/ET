//
//  LicenseRequestController.swift
//  ET
//
//  Created by njoool  on 12/02/2018.
//  Copyright © 2018 com.GP.ET. All rights reserved.
//

import UIKit
import Firebase
class LicenseRequestController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    

var ref : DatabaseReference?
    @IBOutlet weak var noRequestsLabel: UILabel!
    @IBOutlet weak var requestsTable: UITableView!
    var requesta=[NSDictionary]()
    override func viewDidLoad() {
        super.viewDidLoad()
        requestsTable.delegate=self
        requestsTable.dataSource=self
        
        requestsTable.tableFooterView = UIView()
        ref=Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        ref?.child("IssuedEventsRequests").queryOrdered(byChild: "SPID").queryEqual(toValue:uid!).observe(.value) { (snapshot) in
            if snapshot.exists(){
                print("im here")
                self.requestsTable.isHidden = false
                self.noRequestsLabel.isHidden = true
                self.requesta.removeAll()
                let data=snapshot.value! as! NSDictionary
                let all=data.allValues as! [NSDictionary]
                for d in all{
                    self.requesta.append(d)
                    self.requestsTable.reloadData()
                }
                
            }else{
                print("hi")
                self.requestsTable.isHidden=true
                self.noRequestsLabel.isHidden=false
            }
        }
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(requesta.count,"ccoouunntt")
       return requesta.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
             let cell = tableView.dequeueReusableCell(withIdentifier:"cell", for: indexPath) as! RequestStatusCell
        let request=self.requesta[indexPath.row]
        cell.eventName.text = request.value(forKey:"EventName") as! String
        let status=request.value(forKey:"status")as! String
        switch status{
        case "Approved":
            cell.status.text="Approved"
            cell.status.backgroundColor = UIColor(red: 0.1255, green: 0.7373, blue: 0.349, alpha: 1.0)
            break;
        case "Declined":
             cell.status.text="Declined"
             cell.status.backgroundColor = UIColor(red: 0.9373, green: 0.0745, blue: 0, alpha: 1.0)
             break;
        case "Pending":
            cell.status.text="Pending"
            cell.status.backgroundColor=UIColor.lightGray
            break;
        default:
            print("default")
        }
        cell.SetStatus()
        return cell
    }
  
    
 

}
