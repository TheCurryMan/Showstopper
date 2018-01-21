//
//  LoadingViewController.swift
//  Showstopper
//
//  Created by Avinash Jain on 1/20/18.
//  Copyright © 2018 Avinash Jain. All rights reserved.
//

import UIKit
import ChameleonFramework
import KDLoadingView
import SwiftLocation
import Firebase

class LoadingViewController: UIViewController {

    @IBOutlet weak var loadingView: KDLoadingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingView.startAnimating()
        
        updateData()
        
         self.view.backgroundColor = UIColor(gradientStyle: .topToBottom, withFrame: self.view.frame, andColors: [HexColor("#ee0979")!, HexColor("#ff6a00")!])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: {
            self.performSegue(withIdentifier: "loadingtohome", sender: self)
        })

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateData() {
        let ref: DatabaseReference = Database.database().reference()
        var cu = User.currentUser
        Locator.subscribePosition(accuracy: .house, onUpdate: { loc in
            let lat = loc.coordinate.longitude
            let long = loc.coordinate.latitude
            let data = ["lat": lat,
                        "long": long]
            ref.child("users").child("\(cu.UID!)").updateChildValues(data)
        }, onFail: { err, last in
            print("Failed with error: \(err)")
        })
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
