//
//  IssueReqViewController.swift
//  ET
//
//  Created by Wejdan Aziz on 04/03/2018.
//  Copyright © 2018 com.GP.ET. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage


class IssueReqViewController: UIViewController , UIScrollViewDelegate , UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource , UIPickerViewDataSource, UISearchBarDelegate, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
      return cities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cities[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        City.text = cities[row]
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == Audience{return audience.count}
        else{return Categories.count}
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CollectionViewCell=collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
     
        if collectionView==Audience{
            cell.image.image = UIImage(named: String(format: "image%i",indexPath.row))
            cell.image.highlightedImage = UIImage(named: String(format: "image%i-",indexPath.row))
            cell.filterName.text=self.audience[indexPath.row]
            audience_ = self.audience[indexPath.row]
            return cell
        }
        else{
            cell.image.image = UIImage(named: String(format: "image_%i",indexPath.row))
            cell.image.highlightedImage = UIImage(named: String(format: "image_%i-",indexPath.row))
            cell.filterName.text=Categories[indexPath.row]
            category = Categories[indexPath.row]
            return cell
        }
        
    }

 
    var cities = ["Abha", "Abqaiq", "Al Bukaireya", "Al Ghat", "Al Wejh", "Alahsa", "Albaha", "Aldiriya", "Aljof", "All regoins", "Almadina", "Almethneb", "Alras", "Aqla", "Arar", "Ashegr", "Asir", "Bani-Malik (Aldayer)", "Bdaya", "Beshaa", "Buraidah", "Dammam", "Dareen", "delm", "Dhahran", "Dhurma", "Eidabi", "Hafof", "Hafr Albatn", "Hail", "Hota", "Hotat Bani Tamim", "Huraymila", "Industrial Yanbu", "Jazan", "Jeddah", "Jobail", "Khafji", "Khamees Mesheet", "Kharj", "Khobar", "King Abdullah Economic City", "Makkah","Nairyah", "Najran", "Qatif", "Qunfudhah", "Quraiat", "Rabigh", "Rafha", "Riyadh", "Riyadh Al Khabra", "Sabia", "Shagraa", "Sihat", "Skaka", "Tabouk", "Taif", "Tayma", "Umluj", "Unizah", "Wadi Aldawaser", "Yanbu"]
    
    @IBOutlet weak var NumOfTickets: HoshiTextField!
    @IBOutlet weak var TicketPrice: HoshiTextField!
    var storageRef = Storage.storage().reference()
    @IBOutlet weak var ERules: UITextView!
    var ref = Database.database().reference()
    var locTitle = ""
    var secondcoordinate = 0.0
    var Firstcoordinate = 0.0
    var PI = Int()
    @IBOutlet weak var Pages: UIPageControl!
    @IBOutlet weak var Cost: HoshiTextField!
    @IBOutlet weak var Earnings: HoshiTextField!
    @IBOutlet weak var EventImg: UIImageView!
    @IBOutlet weak var FirstView: UIView!
    @IBOutlet weak var EventDiscription: UITextView!
    @IBOutlet weak var ScrollVIew: UIScrollView!
    @IBOutlet weak var SDate : UITextField!
    @IBOutlet weak var LocationCapacity: HoshiTextField!
    @IBOutlet weak var City: HoshiTextField!
    @IBOutlet weak var CTime: HoshiTextField!
    @IBOutlet weak var OTime: HoshiTextField!
    @IBOutlet weak var EDate: HoshiTextField!
    @IBOutlet weak var EventName: HoshiTextField!
    var randomID : String = ""
    @IBOutlet weak var Attend: HoshiTextField!
    @IBOutlet weak var cstegory: UICollectionView!
    @IBOutlet weak var Audience: UICollectionView!
    let audience=["Family","Male","Female","Children"]
    let Categories = ["Art & Culture","Canival","Education","Exhibition","Festival","Gaming","Music","Showa & Preformance","Sports"]
    var Dpicker = UIDatePicker()
    var Dpicker2 = UIDatePicker()
    var Tpicker = UIDatePicker()
    var Tpicker2 = UIDatePicker()
    var xOffset = CGFloat()
    var yOffset = CGFloat()
    var citiesPicker = UIPickerView()
    var category: String!
    var audience_:String!

    override func viewDidLoad() {
        super.viewDidLoad()
        createdatepicker()
        Audience.delegate=self
        Audience.dataSource=self
        cstegory.delegate=self
        cstegory.dataSource=self
        cstegory.showsVerticalScrollIndicator = true
        Audience.showsVerticalScrollIndicator=true
        Audience.flashScrollIndicators()
        citiesPicker.delegate = self
        City.inputView = citiesPicker
    
      //  ref = Database.database().reference()
        randomID = ref.childByAutoId().key
        // Do any additional setup after loading the view, typically from a nib.
    }

        // Do any additional setup after loading the view

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        self.ScrollVIew.delegate = self
        let pickerView = UIPickerView()
        pickerView.delegate = self
        City.inputView = pickerView
        
        // Dispose of any resources that can be recreated.
    }
    
   @IBAction func ChangePage(_ sender: UIPageControl) {
        switch sender.currentPage {
        case 0:
            ScrollVIew?.setContentOffset(CGPoint(x:0 , y: 0), animated: true)
        case 1:
            print(sender.currentPage)
            ScrollVIew?.setContentOffset(CGPoint(x:375 , y: 0), animated: true)
        default:
            print("Defult")
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        xOffset = scrollView.contentOffset.x;
        yOffset = scrollView.contentOffset.y;
        switch xOffset {
        case 0:
            self.Pages.currentPage = 0
        case 375:
            self.Pages.currentPage = 1
        default:
            self.Pages.currentPage = 0
        }
    }
    //-----Date picker--------
    func createdatepicker() {
        
        Dpicker.datePickerMode = .date
        Dpicker2.datePickerMode = .date
        Tpicker2.datePickerMode = .time
        Tpicker.datePickerMode = .time
        let tollbar = UIToolbar()
        tollbar.sizeToFit()
        
        let tollbar2 = UIToolbar()
        tollbar2.sizeToFit()
        
        let toolbar3 = UIToolbar()
        toolbar3.sizeToFit()
        
        let toolbar4 = UIToolbar()
        toolbar4.sizeToFit()
        
        
        let donebutton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done1))
        let donebutton2 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done2))
        let donebutton3 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done3))
        let donebutton4 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done4))
        tollbar.setItems([donebutton], animated: true)
        SDate.inputAccessoryView = tollbar
         tollbar2.setItems([donebutton2], animated: true)
        EDate.inputAccessoryView = tollbar2
        SDate.inputView = Dpicker
        EDate.inputView = Dpicker2
        
       toolbar3.setItems([donebutton3], animated: true)
       OTime.inputAccessoryView = toolbar3
        OTime.inputView = Tpicker
        toolbar4.setItems([donebutton4], animated: true)
        CTime.inputAccessoryView = toolbar4
        CTime.inputView = Tpicker2
        
        
        
    }
   
  //----------Done Datepickers ---------------
  
    @objc func done1() {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd/mm/yyyy"
        let date = dateformatter.string(from: Dpicker.date)
        SDate.text = date
        self.view.endEditing(true)
    }
     @objc func done2() {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd/mm/yyyy"
        let date2 = dateformatter.string(from: Dpicker2.date)
        EDate.text = date2
        self.view.endEditing(true)
    }
    @objc func done3() {
        let calendar = Calendar.current
       
        let minutes = calendar.component(.minute, from: Tpicker.date)
        
        var hour = calendar.component(.hour, from: Tpicker.date)
        if hour > 12 {
            hour = hour - 12
            let hourPM = "\(hour):\(minutes)PM"
              OTime.text = hourPM
        }
        if hour == 0 {
            hour = 12
            let hourAM = "\(hour):\(minutes)AM"
            OTime.text = hourAM
        }
        else {
            let hourAM = "\(hour):\(minutes)AM"
            OTime.text = hourAM
        }
        
        
        
        self.view.endEditing(true)
    }
    
    
    
    @objc func done4() {
        let calendar = Calendar.current
        var hour = calendar.component(.hour, from: Tpicker2.date)
        let minutes = calendar.component(.minute, from: Tpicker2.date)
        if hour > 12 {
            hour = hour - 12
            let hourPM = "\(hour):\(minutes)PM"
            CTime.text = hourPM
        }
        if hour == 0 {
            hour = 12
            let hourAM = "\(hour):\(minutes)AM"
            CTime.text = hourAM
        }
        else {
            let hourAM = "\(hour):\(minutes)AM"
            CTime.text = hourAM
        }
        self.view.endEditing(true)
    }
    
// Map viwe ----------------------------------------------------
    
    @IBOutlet var MapView: UIView!
    
    @IBAction func openmap(_ sender: Any) {
        self.view.addSubview(MapView)
    }
    
    @IBOutlet weak var myMapView: MKMapView!
    
    @IBAction func searchButton(_ sender: Any)
    {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = true
        present(searchController, animated: true, completion: nil)
    }
    
    func popUpMessage(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        //Ignoring user
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        //Activity Indicator
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        //  self.view.addSubview(activityIndicator)
        
        //Hide search bar
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        //Create the search request
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = searchBar.text!
        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(24.774265, 46.738586)
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(coordinate, span)
        searchRequest.region = region
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start { (response, error) in
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            
            if (response == nil || response?.mapItems[0].placemark.countryCode != "SA")
            {
                self.popUpMessage(title: "  Can't find place", message: "Sorry, can't find \(searchBar.text!) in Saudi Arabia, please write the complete name.")
                self.locTitle = ""}
            else
            {
                //Remove annotations
                let annotations = self.myMapView.annotations
                self.myMapView.removeAnnotations(annotations)
                
                //Getting data
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                self.secondcoordinate = (longitude)!
                self.Firstcoordinate = (latitude)!
                self.locTitle = searchBar.text!
                //Create annotation
                let annotation = MKPointAnnotation()
                annotation.title = searchBar.text
                annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                self.myMapView.addAnnotation(annotation)
                //Zooming in on annotation
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                let span = MKCoordinateSpanMake(0.1, 0.1)
                let region = MKCoordinateRegionMake(coordinate, span)
                self.myMapView.setRegion(region, animated: true)
            }
            
        }
    }
    
    @IBAction func Choose(_ sender: Any) {
        if (locTitle == ""){
            self.popUpMessage(title: "Choose a place", message: "Please you have to search for a place first.")
        }
        else{
            MapView.removeFromSuperview()
        }
        
    }
    
//--------------------------------------------------------------

    @IBAction func AddPic(_ sender: UIButton) {
        let image = UIImagePickerController()
        image.delegate = self 
        
        let imgSource = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        imgSource.addAction(UIAlertAction(title: "Camera", style: .default, handler: { ( ACTION: UIAlertAction) in image.sourceType = .camera
            self.present(image, animated: true , completion: nil)
        }))
        
        
        imgSource.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { ( ACTION: UIAlertAction) in image.sourceType = .photoLibrary
            self.present(image, animated: true , completion: nil)
        }))
        
        
        imgSource.addAction(UIAlertAction(title: "Cancel", style: .default, handler:nil ))
        self.present(imgSource , animated: true , completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
    
            EventImg.image = image
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func IssueRequestAction(_ sender: UIButton) {
        if(TicketPrice.text! == "" || NumOfTickets.text! == ""){
            TicketPrice.text = "0"
            NumOfTickets.text = "0"
        }
        var flag = Bool()
        flag = self.EventName.text! == "" ||  self.Attend.text! == "" || self.Cost.text! == "" || self.Earnings.text! == "" || self.EventDiscription.text! == "" || self.SDate.text! == "" || self.LocationCapacity.text! == "" || self.City.text! == "" || self.CTime.text! == "" || self.OTime.text! == "" || self.EDate.text! == "" || self.ERules.text == "" || self.audience_ == "" || self.category == "" || self.locTitle == ""
        if(flag){
            let alert = UIAlertController(title: "Error", message: "Feilds with * is required please fill all the required fields", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        
        else{
           
            var uid=Auth.auth().currentUser?.uid
            
            ref.child("IssuedEventsRequests").child(randomID).setValue(["EventName":self.EventName.text! , "EventDiscription" : self.EventDiscription.text! , "SDate":self.SDate.text! , "EDate":self.EDate.text! , "OpenTime": self.OTime.text! , "CloseTime" : self.CTime.text! , "ExpectedAttendees" : self.Attend.text! , "Cost" : self.Cost.text!, "Earnings":self.Earnings.text! , "LocationCapacity" : self.LocationCapacity.text! ,"City" : self.City.text! , "EventRules": self.ERules.text! , "audience" : self.audience_! , "category":self.category , "TicketPrice" : self.TicketPrice.text! , "NumOfTickets": self.NumOfTickets.text!,"ID":randomID,"locTitle" : locTitle, "secondcoordinate" : secondcoordinate, "Firstcoordinate" : Firstcoordinate,"SPID":"\(uid!)", "status" : "Pending"])
            
            if let imageData: Data = UIImagePNGRepresentation(self.EventImg.image!)!
            {
                let VPicStorageRef = self.storageRef.child("ReqEvent/\(self.EventName.text)/Pic")
                let uploadTask = VPicStorageRef.putData(imageData, metadata: nil)
                {metadata,error in
                    if(error == nil)
                    {
                        let downloadUrl = metadata!.downloadURL()
                        self.ref.child("IssuedEventsRequests").child(self.randomID).child("pic").setValue(String(describing:downloadUrl!))
                        _ = self.navigationController?.popViewController(animated: true)
                        
                    }
                    else {print(error!.localizedDescription)}
                }
            }
            let alertController = UIAlertController(title: "Success", message: "Your request has been issued successfully", preferredStyle: .alert)
            
            // Create OK button
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                
                // Code in this block will trigger when OK button tapped.
                print("Ok button tapped");
                  self.performSegue(withIdentifier:"done", sender:AnyClass.self)
            }
            alertController.addAction(OKAction)
             self.present(alertController, animated: true, completion:nil)
    }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="done"{
            let page=segue.destination as! UITabBarController
            page.selectedIndex = 1
        }
    }
    @IBAction func backPressed(_ sender: UIButton) {
        self.dismiss(animated:true, completion:nil)
    }
    
    
}
