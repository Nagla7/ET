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
class MyEventViewController: UIViewController , UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var MyEventCollv: UICollectionView!
    var Events = [NSDictionary]()
    var dbHandle:DatabaseHandle?
    var ref : DatabaseReference!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        MyEventCollv.delegate = self
        MyEventCollv.dataSource = self
        let uid = Auth.auth().currentUser?.uid
        print(uid,"USERRRRR")
        ref = Database.database().reference()
        dbHandle = ref?.child("Events").observe(.value, with: { (snapshot) in
            if (snapshot.value as? [String:Any]) != nil {
                
                if let data=snapshot.value as? [String:Any] {
                    
                    for(_,value) in data{
                        let Event = value as! NSDictionary
                        if Event["SPID"] as? String == uid {
                            self.Events.append(Event) }
                    }
                    self.MyEventCollv.reloadData()}
                 else {print("No events")}
            }})
        print(Events.count,"76867898987")
        }
    
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return Events.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyEventCollectionViewCell
            var pic: String
            print("e££(@)")
            let Event : NSDictionary?
            Event = Events[indexPath.row]
            pic = (Event!["pic"] as? String)!
            let url=URL(string:pic)
            cell.eventImg.sd_setImage(with:url, completed:nil)
            print("e££(dcd@)")
            return(cell)
            
        }
        // Do any additional setup after loading the view.
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
