//
//  MainPage.swift
//  ET
//
//  Created by rano2 on 31/01/2018.
//  Copyright © 2018 com.GP.ET. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class MainPageController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var NoEventLabel: UILabel!
    @IBOutlet weak var loginbtn: UIBarButtonItem!
    @IBOutlet weak var EventTable: UITableView!
    var ref : DatabaseReference!
    var dbHandle:DatabaseHandle?
    
    var Events=[String:NSDictionary]()
    override func viewDidLoad() {
super.viewDidLoad()
        let uid = Auth.auth().currentUser?.uid
        var user : String!
            user = uid
        //print(user,"$$$$$$$$$$$$$$$$$$$")
        ref = Database.database().reference()
        ref.child("Customers").queryOrdered(byChild: "UID").queryEqual(toValue: "AgOk2EJrFgRiQnFHUms7KfTTvfj1").observeSingleEvent(of: .value , with: { snapshot in
            if snapshot.exists() {
                //error message: username already exists
        print("$$$$$$$$$$$$$$$$$$$")}
            else{
                print("@#@##$OOOoops!!!!")
            }
            
        })
            /*.observeSingleEvent(of: .value , with: { (snapshot) in
            if snapshot.exists(){
                print("##$%$%%$%$")
            }
            else{print("@#@OOOOOOPPP!!!!!")}
        })*/
      /*  if (child == nil)
        {print(child,"!!!!!!!!!#$@#########")}
        else
        {self.tabBarController?.tabBar.isHidden=true
            self.loginbtn.isEnabled=false}*/
        
      //  print(Auth.auth().currentUser?.uid,"!@#$$%%^&&^%$#@!@$^&*()")
EventTable.delegate=self
EventTable.dataSource=self
        dbHandle = ref?.child("Events").observe(.value, with: { (snapshot) in
            if snapshot.exists(){
            self.Events=snapshot.value as! [String:NSDictionary]
                self.EventTable.reloadData()
                self.EventTable.isHidden=false
                self.NoEventLabel.isHidden=true}
            else{
                self.EventTable.isHidden=true
                self.NoEventLabel.isHidden=false}
        })
        // Do any additional setup after loading the view.
        
        //////////////////////search////////////////////////
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.Events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:EventCell=EventTable.dequeueReusableCell(withIdentifier:"cell") as! EventCell
        cell.E_image.clipsToBounds = true
        cell.E_image.layer.borderWidth = 2.0
        cell.E_image.layer.borderColor = UIColor.white.cgColor
        cell.E_image.layer.cornerRadius = 7
        return cell
    }
}
