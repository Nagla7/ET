//
//  MapViewController.swift
//  ET
//
//  Created by njoool  on 17/02/2018.
//  Copyright © 2018 com.GP.ET. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController {

    @IBOutlet weak var navigation: UINavigationBar!
        @IBOutlet weak var map: MKMapView!
        var Event=NSDictionary()
    
    
    override func viewDidLoad() {
        // navigation hight
        navigation.frame = CGRect(x: 0, y: 0, width:  view.frame.width, height: 50)
        
        let initialLocation = CLLocation(latitude: 24.774265, longitude: 46.738586)
        centerMapOnLocation(location: initialLocation)
        
        // Take information
        let title = Event["locTitle"] as! String
        let latitude = Event["Firstcoordinate"] as! NSNumber
        let longitude = Event["secondcoordinate"] as! NSNumber
        // show artwork on map
        let loc = Locatioin(title: title,
                            coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude)))
        map.addAnnotation(loc)
        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(CLLocationDegrees(latitude), CLLocationDegrees(longitude))
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(coordinate, span)
        self.map.setRegion(region, animated: true)
        
    }
    
    let regionRadius: CLLocationDistance = 1800000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        map.setRegion(coordinateRegion, animated: true)
    }
    
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
    @IBAction func Return(_ sender: Any) {
        performSegue( withIdentifier: "return", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "return"){
            self.presentingViewController?.dismiss(animated: true, completion:nil)
            let destination=segue.destination as! EventInfoController
            destination.Event=self.Event}
    }
}
