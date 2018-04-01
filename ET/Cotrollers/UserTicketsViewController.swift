//
//  UserTicketsViewController.swift
//  ET
//
//  Created by rano2 on 02/04/2018.
//  Copyright © 2018 com.GP.ET. All rights reserved.
//

import UIKit
import Firebase
class UserTicketsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.Tickets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier:"cell", for: indexPath) as! TicketCell
        var str=self.Tickets[indexPath.row]
        cell.QR.image=generateQRCode(from:str)
        cell.details.text=str
        return cell
    }
    
    
    @IBOutlet weak var NoTickets: UILabel!
    @IBOutlet weak var TicketTable: UITableView!
    var Tickets=[String]()
    var ref : DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref=Database.database().reference()
        TicketTable.delegate=self
        TicketTable.dataSource=self
        var uid = Auth.auth().currentUser?.uid
  
        if uid != nil{
            ref.child("Tickets").queryOrdered(byChild: "UID").queryEqual(toValue:uid!).observe(.value,with:{ (snapshot) in
                if snapshot.exists(){
                    self.TicketTable.isHidden=false
                    self.NoTickets.isHidden=true
                    var data=snapshot.value! as! NSDictionary
                    var all=data.allValues as! [NSDictionary]
                    for d in all{
                        self.Tickets.append(d.value(forKey:"Data") as! String)
                    }
                    self.TicketTable.reloadData()
                }else{
                    self.TicketTable.isHidden=true
                    self.NoTickets.isHidden=false
                    self.TicketTable.reloadData()
                }
            })
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }

}
