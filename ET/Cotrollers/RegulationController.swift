//
//  RegulationController.swift
//  GEA
//
//  Created by njoool  on 13/02/2018.
//  Copyright © 2018 com.GP.ET. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class RegulationController: UIViewController, UITableViewDelegate, UITableViewDataSource {


        @IBOutlet weak var tableView: UITableView!
        var ref : DatabaseReference!
        var dbHandle:DatabaseHandle?
        var Regulations = [NSDictionary?]()
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            tableView.delegate=self
            tableView.dataSource=self
            ref=Database.database().reference()
            dbHandle = ref?.child("Regulations").observe(.value, with: { (snapshot) in
                let deta=snapshot.value as! [String:Any]
                print(deta)
                for (_,value) in deta{
                    let Regulation=value as! NSDictionary
                    self.Regulations.append(Regulation)
                }
                
                self.tableView.reloadData()})
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        
        func numberOfSections(in tableView: UITableView) -> Int {
            
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return Regulations.count
        }
        
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RegulationControllerTableViewCell
            
            let Regulation : NSDictionary?
            
            Regulation = Regulations[indexPath.row]
            cell.RegulationText.layer.masksToBounds=true
            cell.RegulationText.layer.cornerRadius=10
            cell.RegulationText.text = Regulation?["Description"] as! String
            
            return(cell)
        }

        
}


