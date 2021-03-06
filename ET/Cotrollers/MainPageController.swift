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
class MainPageController: UIViewController,EventDelegate,RatingDelegate,UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UISearchBarDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var NoLabel: UILabel!
    @IBOutlet var collection: UICollectionView!
    @IBOutlet var category: UICollectionView!
   // @IBOutlet weak var NoEventLabel: UILabel!
    @IBOutlet weak var loginbtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    var ref : DatabaseReference!
    var dbHandle:DatabaseHandle?
    var Events=[String : NSDictionary]()
    var filtredEvents = [NSDictionary?]()
    var SendfiltredEvents = [NSDictionary?]()
    var fullEvents = [NSDictionary?]()
    var Rating = [String:NSDictionary]()
    var RatigNo=[Int]()
    var EventObj=Model()
    var Cellid = Int()
    let audience=["Family","Male","Female","Children"]
    let Categories = ["Art & Culture","Canival","Education","Exhibition","Festival","Gaming","Music","Showa & Preformance","Sports","Free"]
    //  let categories=[String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        category.showsHorizontalScrollIndicator = true
        category.flashScrollIndicators()
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self as? UISearchResultsUpdating
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        //self.tableView.register(UITableViewCell.self , forCellReuseIdentifier: "recell")
        tableView.delegate=self
        tableView.dataSource=self
        EventObj.delegate=self
        EventObj.RateDelegate=self
        collection.allowsMultipleSelection=true
        category.allowsMultipleSelection=true
        let uid = Auth.auth().currentUser?.uid
        var user : String!
        user = uid
        
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
        EventObj.getRatings()
    }
    
    
    func recieveEvents(data: [String : NSDictionary]) {
        if data.count != 0{
         self.fullEvents.removeAll()
            self.NoLabel.isHidden=true
            self.tableView.isHidden=false
            for (_,value) in data{
                self.fullEvents.append(value)
            }
            DispatchQueue.main.async { self.tableView.reloadData()}}
        else{self.NoLabel.text="There are No Events"
            self.NoLabel.isHidden=false
            self.tableView.isHidden=true}
    }
    
    func recieveRating(data:[String:NSDictionary]) {
        if data.count != 0{
            self.Rating=data
              /*  var avg=0;
                for (_,ev)in self.Events{
                    var event=ev as! NSDictionary
                    if let rate = data[event["ID"]as! String]{
                        
                    }
                }*/
        
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != ""{
            return filtredEvents.count
        }
        else{
            if(self.fullEvents.count != 0){
                self.NoLabel.isHidden=true}
            return self.fullEvents.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:EventCell=tableView.dequeueReusableCell(withIdentifier:"cell") as! EventCell
        let event : NSDictionary?
        
        if searchController.isActive && searchController.searchBar.text != ""{
            event = self.filtredEvents[indexPath.row]
        }
        else
        { event = self.fullEvents[indexPath.row]
        }
        
        var rate=NSDictionary()
        
        if let rate = self.Rating[event!["ID"]as! String]{
            var avg=0;
            for (_,value) in rate{
                var v=value as! NSDictionary
            avg=avg+((v.value(forKey:"rate")) as! Int)}
        avg=avg/(rate.count)
            for var i in 0..<avg {
                cell.Stars[i] .setTitle("★", for: UIControlState.normal )}}
            else{
                for var i in 0..<cell.Stars.count {
                    cell.Stars[i] .setTitle("☆", for: UIControlState.normal )
                }}
        cell.title.text = event!["title"] as? String
        cell.E_image.clipsToBounds = true
        cell.E_image.layer.borderWidth = 2.0
        cell.E_image.layer.borderColor = UIColor.white.cgColor
        cell.E_image.layer.cornerRadius = 7
        cell.E_image.backgroundColor = UIColor.clear
        var pic: String
        if let pic = event!["pic"] as? String{
        var url=URL(string:pic)
        cell.E_image.sd_setImage(with:url, completed:nil)}
        
        
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
            if self.filtredEvents.count == 0{
                self.NoLabel.text="Can not find what you are searching for."
                self.NoLabel.isHidden=false
               // self.tableView.isHidden=true
            }
            else
            {self.NoLabel.isHidden=true
                self.tableView.isHidden=false}
            
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SendfiltredEvents = filtredEvents
        self.Cellid = indexPath.row
        performSegue(withIdentifier:"goInfo", sender: EventCell())
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let _=sender as? EventCell{
            if searchController.isActive || searchController.searchBar.text != ""{
                searchController.isActive = false
                let event = self.SendfiltredEvents[self.Cellid]
                let destination=segue.destination as! EventInfoController
                destination.Event=event!
                if let rate=self.Rating[event!["ID"] as! String]as?NSDictionary{
                   // print(rate,"***************Rate******************")
                    if let myRate=rate[Auth.auth().currentUser?.uid] as? Int{
                      //print(myRate,"$$$$$$$$$$$myRate$$$$$$$$$$$")
                        destination.Rate=myRate
                    }
                }
            }else{
                let event = self.fullEvents[self.Cellid]
                let destination=segue.destination as! EventInfoController
                destination.Event=event!
                if let rate=self.Rating[event!["ID"] as! String]as?NSDictionary{
                   // print(rate,"***************Rate******************")
                    if let myRate=rate[Auth.auth().currentUser?.uid]as? NSDictionary{
                      //  print(myRate,"$$$$$$$$$$$myRate$$$$$$$$$$$")
                        destination.Rate=myRate.value(forKey:"rate") as! Int
                    }
                }
            }
        }
    }
    
    //=====================Filter===============
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView==collection{
            return 4}
        else{
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CollectionViewCell=collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        if collectionView==collection{
            cell.image.image = UIImage(named: String(format: "image%i",indexPath.row))
            cell.image.highlightedImage = UIImage(named: String(format: "image%i-",indexPath.row))
            cell.filterName.text=self.audience[indexPath.row]
            return cell
        }
        else{
            cell.image.image = UIImage(named: String(format: "image_%i",indexPath.row))
            cell.image.highlightedImage = UIImage(named: String(format: "image_%i-",indexPath.row))
            cell.filterName.text=Categories[indexPath.row]
            return cell
        }
        
    }
    
    @IBOutlet var FilterView: UIView!
    
    @IBAction func openFilter(_ sender: Any) {
        self.view.addSubview(FilterView)
    }
    ///////////////////////pickerView//////////////////////
    @IBOutlet weak var pickerView: UIPickerView!
    
    let cities = ["All","Abha", "Abqaiq", "Al Bukaireya", "Al Ghat", "Al Wejh", "Alahsa", "Albaha", "Aldiriya", "Aljof", "Almadina", "Almethneb", "Alras", "Aqla", "Arar", "Ashegr", "Asir", "Bani-Malik (Aldayer)", "Bdaya", "Beshaa", "Buraidah", "Dammam", "Dareen", "delm", "Dhahran", "Dhurma", "Eidabi", "Hafof", "Hafr Albatn", "Hail", "Hota", "Hotat Bani Tamim", "Huraymila", "Industrial Yanbu", "Jazan", "Jeddah", "Jobail", "Khafji", "Khamees Mesheet", "Kharj", "Khobar", "King Abdullah Economic City", "Makkah","Nairyah", "Najran", "Qatif", "Qunfudhah", "Quraiat", "Rabigh", "Rafha", "Riyadh", "Riyadh Al Khabra", "Sabia", "Shagraa", "Sihat", "Skaka", "Tabouk", "Taif", "Tayma", "Umluj", "Unizah", "Wadi Aldawaser", "Yanbu"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cities[row]
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cities.count
    }
    
    var city = "All"
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        city = cities[row]
    }
    
    var selectedAudience = [String] ()
    var selectedCategories = [String] ()
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell:CollectionViewCell=collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        if (collectionView==collection && cell.isSelected == false){
            selectedAudience.append(self.audience[indexPath.row])}
        else {
            if (collectionView==collection && cell.isSelected == true && selectedAudience.contains(self.audience[indexPath.row])){
                selectedAudience = selectedAudience.filter { $0 != self.audience[indexPath.row] }
            }
        }
            if (category==collectionView && cell.isSelected == false){
            selectedCategories.append(self.Categories[indexPath.row])}
            else {
                if (collectionView==category && cell.isSelected == true && selectedCategories.contains(self.Categories[indexPath.row])){
                    selectedCategories = selectedCategories.filter { $0 != self.Categories[indexPath.row] }
                }
        }
        
    }
    
    
    @IBAction func Filter(_ sender: Any) {
        var emptyAudience = false
        var emptyCategories = false
        let fulleventsfilter = fullEvents
        
        if (selectedAudience.count == 0)
        {selectedAudience = audience
            emptyAudience = true
        }
        
        if (selectedCategories.count == 0)
        {selectedCategories = Categories
            emptyCategories = true
        }
        
        var i:Int = 0
            self.fullEvents = self.fullEvents.filter{ event in
                let Cityelement = fullEvents[i]!["City"] as! String
                let Categoryelemnt = fullEvents[i]!["Category"] as! String
                let Audienceelemnt = fullEvents[i]!["Target Audience"] as! String
                i = 1+i

                        if (city != "All"){                            
                            return(Cityelement.lowercased().contains(city.lowercased()) && selectedAudience.contains(Audienceelemnt) && selectedCategories.contains(Categoryelemnt))}
           return(selectedAudience.contains(Audienceelemnt) && selectedCategories.contains(Categoryelemnt) )
        }
        if self.fullEvents.count == 0{
            self.NoLabel.text="Can not find what you are searching for."
            self.NoLabel.isHidden=false
            self.tableView.isHidden=true
        }else
        
        {self.NoLabel.isHidden=true
            self.tableView.isHidden=false
            self.tableView.reloadData()}
        
        if (emptyAudience)
        {selectedAudience = [String] ()}
        
        if (emptyCategories)
        {selectedCategories = [String] ()}
        FilterView.removeFromSuperview()
    }
    
    
}

