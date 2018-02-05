//
//  MainPage.swift
//  ET
//
//  Created by rano2 on 31/01/2018.
//  Copyright © 2018 com.GP.ET. All rights reserved.
//

import UIKit

class MainPageController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var E_image: UIImageView!
    @IBOutlet weak var EventTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
EventTable.delegate=self
EventTable.dataSource=self
        // Do any additional setup after loading the view.
        
        //////////////////////search////////////////////////
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
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
