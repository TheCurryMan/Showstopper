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

class LoadingMapViewController: UIViewController {
    
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
    
    func updateToNetwork(userId: String, speechId: String, completion: @escaping ((Result<Void>) -> Void)) {
        let requestString = "http://mysterious-shelf-30539.herokuapp.com/geo"
        
        let params =  ["id": User.currentUser.UID!] as Parameters
        
        Alamofire.request(requestString, method: .get, parameters: params, encoding: URLEncoding(destination: .queryString), headers: nil).responseJSON { (response) in
            
            guard let status = response.response?.statusCode else {
                completion(.failure("unable to get status code" as! Error))
                return
            }
            if status != 200   {
                completion(.failure("Staus: \(status)" as! Error))
            }
            
            guard let result = response.result.value, let json = result as? NSDictionary else {
                completion(.failure("failed to get the response" as! Error))
                return
            }
            
            if let userIds = json.allKeys as? [String] {
                self.userIds = userIds
            }
            
            for i in self.userIds {
                if let coords = json[i] as? (Float, Float) {
                    var a = Artwork(coordinate: CLLocationCoordinate2DMake(CLLocationDegrees(coords.0), CLLocationDegrees(coords.1)))
                    self.mapView.addAnnotation(a)
                }
            }
            
            UIView.animate(withDuration: 1, animations: {
                self.mapView.frame.origin.y -= 100
                self.pulsator.stop()
            }, completion: {(b) in
                self.foundLabel.text = "Found \(self.userIds.count) outfits"
                self.scanLabel.isHidden = false
                self.scanLabel.text = "Find them in your collection"
                self.doneButton.isHidden = false
            })
            
            
            //{'00': (37.000003, -122.000002), '01': (37.000003, -122.000002), '03': (37.000009, -122.000004)}
            
            /*
            if let wpm = json["wpm"] as? Double {
                self.feedback.wpm = wpm
            }
            
            if let pausing = json["pausing"] as? String {
                self.feedback.pausing = pausing
            }
            
            if  let similarity = json["similarity"] as? Double {
                self.feedback.similarity = similarity
            }
            
            if let loudness = json["loudness"]  as? String {
                self.feedback.loudness = loudness
            }
            
            if let score = json["score"] as? Double {
                self.feedback.score = score
            }
            
            if let pastData = json["wpm"] as? [String:AnyObject] {
                
                if let wpm = pastData["wpm"] as? Bool {
                    self.feedback.pastData.wpm = wpm
                }
                
                if let pausing = pastData["pausing"] as? Bool {
                    self.feedback.pastData.pausing = pausing
                }
                
                if  let similarity = pastData["similarity"] as? Bool {
                    self.feedback.pastData.similarity = similarity
                }
                
                if let loudness = pastData["loudness"]  as? Bool {
                    self.feedback.pastData.loudness = loudness
                }
            }
            
            self.displayFeedackMessage()
            
            completion(.success(())) */
        }
    }

}
