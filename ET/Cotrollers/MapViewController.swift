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

        
        @IBOutlet weak var map: MKMapView!
        var Event=NSDictionary()
    
        
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view, typically from a nib.
            
            let span:MKCoordinateSpan = MKCoordinateSpanMake(0.1, 0.1)
            let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(37.760122, -122.468158)
            let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
            map.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = location
            annotation.title = "MY SHOP"
            annotation.subtitle = "COME VISIT ME HERE!"
            map.addAnnotation(annotation)
            
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
