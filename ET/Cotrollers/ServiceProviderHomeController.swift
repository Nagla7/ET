//
//  ServiceProviderHomeController.swift
//  ET
//
//  Created by njoool  on 07/02/2018.
//  Copyright © 2018 com.GP.ET. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import SDWebImage

class ServiceProviderHomeController: UIViewController,UITableViewDelegate,UITableViewDataSource,VenueDelegate,UISearchResultsUpdating,UISearchBarDelegate {

    @IBOutlet weak var NoVenues: UILabel!
    @IBOutlet weak var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    var fullVenues = [NSDictionary]()
    var filteredVenues = [NSDictionary]()
    var Venuedelegation=Model()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate=self
        tableView.dataSource=self
        Venuedelegation.Venuedelegate=self
        Venuedelegation.getVenues()
        
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self as? UISearchResultsUpdating
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           if searchController.isActive && searchController.searchBar.text != ""{
         return self.filteredVenues.count
         }
         else{return self.fullVenues.count } }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
              let venue : NSDictionary?
         
         if searchController.isActive && searchController.searchBar.text != ""{
         venue = self.filteredVenues[indexPath.row]}
         else{venue = self.fullVenues[indexPath.row]}
        
        
        // the same cell well be used for events and venues
        let cell:VenueCell=tableView.dequeueReusableCell(withIdentifier:"cell") as! VenueCell
        cell.Vimage.clipsToBounds = true
        cell.Vimage.layer.borderWidth = 2.0
        cell.Vimage.layer.borderColor = UIColor.white.cgColor
        cell.Vimage.layer.cornerRadius = 7
        cell.Vname.text=venue?.value(forKey:"VenueName") as! String
        cell.Vcapacity.text="Capacity: \(venue?.value(forKey:"Capacity") as! String)"
        return cell
    }
    func recieveVenues(data: [String : NSDictionary]) {
        if data.count != 0{
            self.tableView.isHidden=false
    //        self.NoVenues.isHidden=true
            for (_,value) in data{self.fullVenues.append(value)
                self.tableView.reloadData()
            }
            
        }
        else{self.tableView.isHidden=true
  //          self.NoVenues.isHidden=false
            
        }
    }
    func updateSearchResults(for searchController: UISearchController) {
        var i:Int=0
        if searchController.searchBar.text == "" {
            filteredVenues=fullVenues
            self.tableView.reloadData()
        }
            
        else {
            filteredVenues=[NSDictionary]()
            self.filteredVenues = self.fullVenues.filter{ venues in
                let Title = fullVenues[i]["VenueName"] as! String
                i = 1+i
                return(Title.lowercased().contains(searchController.searchBar.text!.lowercased()))
            }
            self.tableView.reloadData()}
    }
}


