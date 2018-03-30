//
//  ViewController.swift
//  showPlaceOnMap
//
//  Created by Sebastian Hette on 28.06.2017.
//  Copyright © 2017 MAGNUMIUM. All rights reserved.
//

import UIKit
import MapKit

class MapLoc: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var myMapView: MKMapView!
    var locTitle = ""
    var secondcoordinate = 0.0
    var Firstcoordinate = 0.0
    
    
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
        
        self.view.addSubview(activityIndicator)
        
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
                self.secondcoordinate = longitude as! Double
                self.Firstcoordinate = latitude as! Double
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
            performSegue( withIdentifier: "chooseLoc", sender: sender)
        }}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "chooseLoc"){
            self.dismiss(animated: true, completion:nil)
            let destination=segue.destination as! IssueReqViewController
            destination.Firstcoordinate=self.Firstcoordinate
            destination.secondcoordinate=self.secondcoordinate
            destination.locTitle=self.locTitle}
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

