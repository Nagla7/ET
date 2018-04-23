//
//  QRScannerViewController.swift
//  ET
//
//  Created by Wejdan Aziz on 02/04/2018.
//  Copyright © 2018 com.GP.ET. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import FirebaseDatabase
import FirebaseAuth

class QRScannerViewController: UIViewController,  AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var Cv: UIView!
    // @IBOutlet weak var square: UIImageView!
    var video = AVCaptureVideoPreviewLayer()
    var ref = Database.database().reference()
    var Event=NSDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //Creating session
        let session = AVCaptureSession()
        
        //Define capture devcie
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        do
        {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session.addInput(input)
        }
        catch
        {
            print ("ERROR")
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = Cv.layer.bounds
        Cv.layer.addSublayer(video)
        
        // self.view.bringSubview(toFront: square)
        
        session.startRunning()
    }
    
    func metadataOutput(_ captureOutput: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if metadataObjects != nil && metadataObjects.count != 0
        {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject
            {
                if object.type == AVMetadataObject.ObjectType.qr
                {
                    
                    let str = object.stringValue
                    print(str,"%%%%%%%%%%%%%%STR%%%%%%%%%%%%%")
                    let result = str?.split(separator:"\n")
                    
                    
                    ref.child("Tickets/\(result![4])").observe(.value, with: { (snapshot) in
                        if snapshot.exists() {
                            print("rerere")
                            print("heere2")
                            let data = snapshot.value  as? [String:Any]
                            let uid = Auth.auth().currentUser?.uid
                            if((data!["SPID"] as! String) == uid){
                                print("sisisi")
                                
                                let formatter = DateFormatter()
                                formatter.dateStyle = .full
                                formatter.dateFormat = "dd/mm/yyyy"
                                
                                let today =  Date()
                                let Edate = formatter.date(from: "\(result![0])" as! String)
                                
                                print("0*******",Edate,today,"*****0")
                                
                                if today > Edate! {
                                    
                                    let alert = UIAlertController(title: "Oops", message: "Sorry your ticket is expired", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                    // let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
                                    //  imageView.image = #imageLiteral(resourceName: "icons8-ok-filled-100")
                                    //  alert.view.addSubview(imageView)
                                    self.present(alert, animated: true, completion: nil)
                                    
                                } else {
                                    let alert = UIAlertController(title: "Success", message: "Valid Ticket", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                }
                            }
                            else{
                                let alert = UIAlertController(title: "Oops", message: "Sorry you cant accsess this ticket", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                // let imgTitle = UIImage(named:"icons8-ok-filled-100.png")
                                // let imgViewTitle = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
                                // imgViewTitle.image = imgTitle
                                //  alert.view.addSubview(imgViewTitle)
                                self.present(alert, animated: true, completion: nil)
                                
                            }
                        }
                        else{
                            let alert = UIAlertController(title: "Oops", message: "Sorry the ticket is invalid", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        } })
                    //let alert = UIAlertController(title: "QR Code", message: object.stringValue, preferredStyle: .alert)
                    // alert.addAction(UIAlertAction(title: "Retake", style: .default, handler: nil))
                    // present(alert, animated: true, completion: nil)
                    
                }
            }
            else{
                
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.dismiss(animated:true, completion:nil)
    }
    
}


