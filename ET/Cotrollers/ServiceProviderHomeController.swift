//
//  ServiceProviderHomeController.swift
//  ET
//
//  Created by njoool  on 07/02/2018.
//  Copyright © 2018 com.GP.ET. All rights reserved.
//

import UIKit

class ServiceProviderHomeController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var E_image: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    var fullVenues = NSDictionary()
    var filteredVenues = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate=self
        tableView.dataSource=self
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
        /*     if searchController.isActive && searchController.searchBar.text != ""{
         return filteredEvents.count
         }
         else{
         return self.fullEvents.count}*/
return 4    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*      let events : NSDictionary?
         
         if searchController.isActive && searchController.searchBar.text != ""{
         
         events = filteredEvents[indexPath.row]
         }
         else
         {
         events = self.fullEvents[indexPath.row]
         }
         */
        
        // the same cell well be used for events and venues
        let cell:EventCell=tableView.dequeueReusableCell(withIdentifier:"cell") as! EventCell
        cell.E_image.clipsToBounds = true
        cell.E_image.layer.borderWidth = 2.0
        cell.E_image.layer.borderColor = UIColor.white.cgColor
        cell.E_image.layer.cornerRadius = 7
        return cell
    }
}


