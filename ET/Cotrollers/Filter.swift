//
//  ViewController.swift
//  filter
//
//  Created by njoool  on 03/02/2018.
//  Copyright © 2018 com.GP.ET. All rights reserved.
//

import UIKit

    
class Filter: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
  /*
     
     UICollectionViewDelegate,UICollectionViewDataSource
     
    @IBOutlet weak var collection: UICollectionView!
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return 2
    }
    
 /   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                let  cell:CollectionViewCell=collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        return cell
    }
    */
        ///////////////////////Shadow//////////////////////
        @IBOutlet weak var one: UIView!
        @IBOutlet weak var second: UIView!
        @IBOutlet weak var thierd: UIView!
    
        func dropShadow(scale: Bool = true) {
            one.layer.masksToBounds = false
            one.layer.shadowColor = UIColor.black.cgColor
            one.layer.shadowOpacity = 0.5
            one.layer.shadowOffset = CGSize(width: -1, height: 1)
            one.layer.shadowRadius = 1
            
            one.layer.shadowPath = UIBezierPath(rect: one.bounds).cgPath
            one.layer.shouldRasterize = true
            one.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
            
            second.layer.masksToBounds = false
            second.layer.shadowColor = UIColor.black.cgColor
            second.layer.shadowOpacity = 0.5
            second.layer.shadowOffset = CGSize(width: -1, height: 1)
            second.layer.shadowRadius = 1
            
            second.layer.shadowPath = UIBezierPath(rect: second.bounds).cgPath
            second.layer.shouldRasterize = true
            second.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
            
            thierd.layer.masksToBounds = false
            thierd.layer.shadowColor = UIColor.black.cgColor
            thierd.layer.shadowOpacity = 0.5
            thierd.layer.shadowOffset = CGSize(width: -1, height: 1)
            thierd.layer.shadowRadius = 1
            
            thierd.layer.shadowPath = UIBezierPath(rect: thierd.bounds).cgPath
            thierd.layer.shouldRasterize = true
            thierd.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
        }
        ///////////////////////Shadow//////////////////////
    
        override func viewDidLoad() {
            
            super.viewDidLoad()
            // Do any additional setup after loading the view, typically from a nib.
            dropShadow()
            }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    ///////////////////////pickerView//////////////////////
        @IBOutlet weak var pickerView: UIPickerView!
        
        let cities = ["All","Abha", "Abqaiq", "Al Bukaireya", "Al Ghat", "Al Wejh", "Alahsa", "Albaha", "Aldiriya", "Aljof", "All regoins", "Almadina", "Almethneb", "Alras", "Aqla", "Arar", "Ashegr", "Asir", "Bani-Malik (Aldayer)", "Bdaya", "Beshaa", "Buraidah", "Dammam", "Dareen", "delm", "Dhahran", "Dhurma", "Eidabi", "Hafof", "Hafr Albatn", "Hail", "Hota", "Hotat Bani Tamim", "Huraymila", "Industrial Yanbu", "Jazan", "Jeddah", "Jobail", "Khafji", "Khamees Mesheet", "Kharj", "Khobar", "King Abdullah Economic City", "Makkah","Nairyah", "Najran", "Qatif", "Qunfudhah", "Quraiat", "Rabigh", "Rafha", "Riyadh", "Riyadh Al Khabra", "Sabia", "Shagraa", "Sihat", "Skaka", "Tabouk", "Taif", "Tayma", "Umluj", "Unizah", "Wadi Aldawaser", "Yanbu"]
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return cities[row]
        }
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return cities.count
        }
        
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            let selested = cities[row]
            print("##################",selested)
        }
        
        
}


