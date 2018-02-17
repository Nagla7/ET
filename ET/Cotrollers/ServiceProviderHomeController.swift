//
//  ServiceProviderHomeController.swift
//  ET
//
//  Created by njoool  on 07/02/2018.
//  Copyright © 2018 com.GP.ET. All rights reserved.
//

import UIKit

class ServiceProviderHomeController: UIViewController,UITableViewDelegate,UITableViewDataSource,VenueDelegate {

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
        // Do any additional setup after loading the view.
        
        //////////////////////search////////////////////////
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
              let events : NSDictionary?
         
         if searchController.isActive && searchController.searchBar.text != ""{
         events = self.filteredVenues[indexPath.row]}
         else{events = self.fullVenues[indexPath.row]}
        
        
        // the same cell well be used for events and venues
        let cell:EventCell=tableView.dequeueReusableCell(withIdentifier:"cell") as! EventCell
      /*  cell.E_image.clipsToBounds = true
        cell.E_image.layer.borderWidth = 2.0
        cell.E_image.layer.borderColor = UIColor.white.cgColor
        cell.E_image.layer.cornerRadius = 7*/
        return cell
    }
    func recieveVenues(data: [String : NSDictionary]) {
        if data.count != 0{
            self.tableView.isHidden=false
            self.NoVenues.isHidden=true
            for (_,value) in data{self.fullVenues.append(value)
                self.tableView.reloadData()
            }
            
        }
        else{self.tableView.isHidden=true
            self.NoVenues.isHidden=false}
    }
    func updateSearchResults(for searchController: UISearchController) {
        var i:Int=0
        if searchController.searchBar.text == "" {
            filteredVenues=fullVenues
            self.tableView.reloadData()
        }
            
        else {
            self.filteredVenues = self.fullVenues.filter{ event in
                let Title = fullVenues[i]["VenueName"] as! String
                i = 1+i
                return(Title.lowercased().contains(searchController.searchBar.text!.lowercased()))
            }
            self.tableView.reloadData()}
    }
}


