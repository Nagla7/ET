//
//  MyEventViewController.swift
//  ET
//
//  Created by Wejdan Aziz on 12/03/2018.
//  Copyright © 2018 com.GP.ET. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SDWebImage
class MyEventViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,EventDelegate {

    
    

    var Events = [NSDictionary]()
    var dbHandle:DatabaseHandle?
    var ref : DatabaseReference!
    var model=Model()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var NoEvent: UILabel!
    var  uid = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        model.delegate=self
        model.getEvents()
        uid=(Auth.auth().currentUser?.uid)!
        }
    
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Events.count != 0{
            self.NoEvent.isHidden=true
            self.tableView.isHidden=false
            return Events.count}
        else{
            self.NoEvent.isHidden=false
            self.tableView.isHidden=true
            return Events.count
        }
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MyEvnt = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyEvnt
        var pic: String
        let Event : NSDictionary?
        Event = Events[indexPath.row]
        if let pic = Event!["pic"] as? String{
        let url=URL(string:pic)
        cell.E_image.sd_setImage(with:url, completed:nil)}
        cell.title.text=Event!["title"] as! String
        return(cell)
    }

            
    
        // Do any additional setup after loading the view.
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated.
    }
    

    func recieveEvents(data: [String : NSDictionary]) {
        print(data,"$$$$$$$$$$$$$$$$$my$$$$$$$$$$$$$$$$")
        if data.count != 0{

            for (_,value) in data{
                var event=value as! NSDictionary
                if event["SPID"] as? String == uid {
                    self.Events.append(event) }
                
            }
           self.tableView.reloadData()
        }

    }

}
