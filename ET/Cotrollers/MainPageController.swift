//
//  MainPage.swift
//  ET
//
//  Created by rano2 on 31/01/2018.
//  Copyright © 2018 com.GP.ET. All rights reserved.
//
import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth
import SDWebImage
class MainPageController: UIViewController ,UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UISearchBarDelegate,EventDelegate {
    @IBOutlet weak var NoEventLabel: UILabel!
    @IBOutlet weak var loginbtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var Cellid = Int()
    var ref : DatabaseReference!
    var dbHandle:DatabaseHandle?
    var Events=[String : NSDictionary]()
    var filtredEvents = [NSDictionary?]()
    var fullEvents = [NSDictionary?]()
    let searchController = UISearchController(searchResultsController: nil)
    var EventObj=Event()
    var selectedEvent:NSDictionary!
    var photos=["https://firebasestorage.googleapis.com/v0/b/gp-et-873cd.appspot.com/o/Events%20pics%2F1.jpg?alt=media&token=2cc8309f-d753-461d-a8d1-4ff59968686f","https://firebasestorage.googleapis.com/v0/b/gp-et-873cd.appspot.com/o/Events%20pics%2Ffantasyworld.jpg?alt=media&token=132d59ac-120a-4c55-8570-bd8ea8b1b528","https://firebasestorage.googleapis.com/v0/b/gp-et-873cd.appspot.com/o/Events%20pics%2Fhakayathumb.jpg?alt=media&token=59a5237b-ff9f-47f2-94a8-accd62da74de","https://firebasestorage.googleapis.com/v0/b/gp-et-873cd.appspot.com/o/Events%20pics%2Flaser_thumb.jpg?alt=media&token=0c572457-bf26-4525-9f90-70cc3956b62b","https://firebasestorage.googleapis.com/v0/b/gp-et-873cd.appspot.com/o/Events%20pics%2Fsharekqudrathumbnail.jpg?alt=media&token=47333259-a7ae-446b-9e9f-82bc2b188d8f","https://firebasestorage.googleapis.com/v0/b/gp-et-873cd.appspot.com/o/Events%20pics%2Ftaif_thumb.jpg?alt=media&token=d86e4507-0692-4ef9-a582-7aaaea055662","https://firebasestorage.googleapis.com/v0/b/gp-et-873cd.appspot.com/o/Events%20pics%2Fthumb.jpg?alt=media&token=823e0b4e-b518-4cf8-b896-0172e3261f04","https://firebasestorage.googleapis.com/v0/b/gp-et-873cd.appspot.com/o/Events%20pics%2Fwonderland2018.jpg?alt=media&token=ca48e200-3d09-48af-a54a-0c7a5cf96f51"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self as? UISearchResultsUpdating
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        self.tableView.register(UITableViewCell.self , forCellReuseIdentifier: "recell")
        tableView.delegate=self
        tableView.dataSource=self
        EventObj.delegate=self
        let uid = Auth.auth().currentUser?.uid
        var user : String!
            user = uid
        
        //print(user,"$$$$$$$$$$$$$$$$$$$")
        ref = Database.database().reference()
        ref.child("Customers").queryOrdered(byChild: "UID").queryEqual(toValue:user).observeSingleEvent(of: .value , with: { snapshot in
            if snapshot.exists() {
                self.tabBarController?.tabBar.isHidden=false
                    self.loginbtn.isHidden=true}
            else{
                self.tabBarController?.tabBar.isHidden=true
                self.loginbtn.isHidden=false
            }
            })
        
        EventObj.getEvents()
       /* if self.Events.count==0{
        self.tableView.isHidden=true
        self.NoEventLabel.isHidden=false}
        else {
            self.tableView.isHidden=false
            self.NoEventLabel.isHidden=true
        }*/
    }
    func recieveEvents(data: [String : NSDictionary]) {
        for (_,value) in data{
            self.fullEvents.append(value)
        }
        DispatchQueue.main.async { self.tableView.reloadData()}
    }
 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != ""{
            return filtredEvents.count
        }
        else{
            return self.fullEvents.count}
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:EventCell=tableView.dequeueReusableCell(withIdentifier:"cell") as! EventCell
        let event : NSDictionary?
        if searchController.isActive && searchController.searchBar.text != ""{
            
            event = self.filtredEvents[indexPath.row]
        }
        else
        {
            event = self.fullEvents[indexPath.row]
            switch event!["Category"]as! String{
            case "Male":
                break
            case "Female":break
            case "Family":break
            default: break
            
            }
        }
        cell.title.text = event!["title"] as? String
        cell.E_image.clipsToBounds = true
        cell.E_image.layer.borderWidth = 2.0
        cell.E_image.layer.borderColor = UIColor.white.cgColor
        cell.E_image.layer.cornerRadius = 7
        cell.index=indexPath.row
        var url=URL(string:self.photos[indexPath.row])
        cell.E_image.sd_setImage(with:url, completed:nil)
        return(cell)
    }

        func updateSearchResults(for searchController: UISearchController) {
            var i:Int=0
            if searchController.searchBar.text == "" {
                filtredEvents=fullEvents
                self.tableView.reloadData()
            }
            
            else {
            filtredEvents=[NSDictionary]()
                self.filtredEvents = self.fullEvents.filter{ event in
                    let Title = fullEvents[i]!["title"] as! String
                    i = 1+i
                return(Title.lowercased().contains(searchController.searchBar.text!.lowercased()))
                }
                self.tableView.reloadData()}
        }

   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.Cellid = indexPath.row
    print(Cellid,"###############")
    performSegue(withIdentifier:"goInfo", sender: EventCell())
}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let _=sender as? EventCell{
            if searchController.isActive && searchController.searchBar.text != ""{
                searchController.isActive = false
                let event = self.filtredEvents[self.Cellid]
                let destination=segue.destination as! EventInfoController
                destination.Event=event!
            }else{
                let event = self.fullEvents[self.Cellid]
                let destination=segue.destination as! EventInfoController
                destination.Event=event!
        }
        }
    }


}
