//
//  LoadingMapViewController.swift
//  Showstopper
//
//  Created by Avinash Jain on 1/21/18.
//  Copyright © 2018 Avinash Jain. All rights reserved.
//

import UIKit
import Pulsator
import MapKit
import CoreLocation
import ChameleonFramework
import Alamofire
import Firebase

class LoadingMapViewController: UIViewController {
    
    @IBOutlet weak var mapViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var foundLabel: UILabel!
    @IBOutlet weak var scanLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    var locManager = CLLocationManager()
    var newPin = MKPointAnnotation()
    var pulsator = Pulsator()
    
    var userIds = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor(gradientStyle: .topToBottom, withFrame: self.view.frame, andColors: [HexColor("#ee0979")!, HexColor("#ff6a00")!])
        
        mapView.layer.cornerRadius = 125
        var arr : [Double] = getCurrentLocation()
        print(arr[0])
        print(arr[1])
        let initialLocation = CLLocation(latitude: arr[0], longitude: arr[1])
        centerMapOnLocation(location: initialLocation)
        // show artwork on map
        let artwork = Artwork(coordinate: CLLocationCoordinate2D(latitude: 36.99434, longitude: -122.07))
        mapView.addAnnotation(artwork)
        addHalo()
        
        updateToNetwork(userId: "02")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func getCurrentLocation() -> Array<Double>
    {
        locManager.requestWhenInUseAuthorization()
        let currentLocation: CLLocation!
        var latlong : [Double] = [37.2997, -122.0035]
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined, .restricted, .denied:
            print("Failed")
        case .authorizedAlways, .authorizedWhenInUse:
            currentLocation = locManager.location
            latlong[0] = currentLocation.coordinate.latitude
            latlong[1] = currentLocation.coordinate.longitude
        }
        
        return latlong
        
    }
    
    func addHalo() {
        pulsator.position = self.view.center
        pulsator.radius = 200
        pulsator.animationDuration = 3
        pulsator.numPulse = 5
        pulsator.backgroundColor = UIColor.white.cgColor
        view.layer.addSublayer(pulsator)
        view.bringSubview(toFront: mapView)
        pulsator.start()
    }
    
    func updateToNetwork(userId: String) {
        let requestString = "http://mysterious-shelf-30539.herokuapp.com/geo"
        
        let params =  ["id": userId] as Parameters
        
        Alamofire.request(requestString, method: .get, parameters: params, encoding: URLEncoding(destination: .queryString), headers: nil).responseJSON { (response) in
            
            guard let status = response.response?.statusCode else {
                print("unable to get status code")
                return
            }
            if status != 200   {
                print("Staus: \(status)")
            }
            
            guard let result = response.result.value, let json = result as? NSDictionary else {
                print("failed to get the response")
                return
            }
            
            if let userIds = json.allKeys as? [String] {
                self.userIds = userIds
                self.addToCollection()
            }
            
            for i in self.userIds {
                if let coords = json[i] as? (Float, Float) {
                    var a = Artwork(coordinate: CLLocationCoordinate2DMake(CLLocationDegrees(coords.0), CLLocationDegrees(coords.1)))
                    self.mapView.addAnnotation(a)
                }
            }
            
            self.mapViewConstraint.constant = -180
            UIView.animate(withDuration: 1, animations: {
                self.view.layoutIfNeeded()
                self.pulsator.stop()
            }, completion: {(b) in
                UIView.animate(withDuration: 1, animations: {
                self.foundLabel.text = "Found \(self.userIds.count) outfits"
                self.foundLabel.isHidden = false
                self.scanLabel.text = "Find them in your collection"
                self.doneButton.isHidden = false
                    self.doneButton.layer.cornerRadius = 5.0
                })
            })
        }
    }
    
    func addToCollection() {
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let dateStr = "\(year)-\(month)-\(day)"
        
        for i in self.userIds {
            print(i)
            var ref :DatabaseReference = Database.database().reference()
            ref.child("users").child(i).child("outfits").child(dateStr).observe(.value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                User.currentUser.getClothingData(i: value!["topID"] as! String, completion:{(top) in
                    User.currentUser.getClothingData(i: value!["botID"] as! String, completion: {(bot) in
                        User.currentUser.getClothingData(i: value!["shoID"] as! String, completion: {(shoe) in
                            User.currentUser.collection.append(Outfit(upperBody: top, lowerBody: bot, shoes: shoe))
                        })
                    })
                })
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func done(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
