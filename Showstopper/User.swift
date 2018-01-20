//
//  User.swift
//  Showstopper
//
//  Created by Avinash Jain on 1/20/18.
//  Copyright © 2018 Avinash Jain. All rights reserved.
//


import Foundation
import Firebase

class User {
    var name : String?
    var UID : String?
    var location: (Float, Float)?
    var closet = Closet()
    var hasCurrentOutfit: Bool?
    var currentOutfit: Outfit?
    
    static var currentUser = User()
    let ref : DatabaseReference = Database.database().reference()
    
    private init() {
    }
    
    func setUID() {
        UID = Auth.auth().currentUser?.uid
    }
    
    func setUpUser() {
        UID = Auth.auth().currentUser?.uid
        
        ref.child("users").child(UID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            self.name = value?["name"] as? String
            //self.location = (value?["lat"] as! Float, value?["long"] as! Float)
            //self.closet = value?["closet"]
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getClosetData() {
        ref.child("users").child(UID!).child("closet").observe(.value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            self.closet.setIds(top: value?["top"] as! [String], bot: value?["bot"] as! [String], shoe: value?["sho"] as! [String])
            
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    func checkCurrentOutfit() -> Bool{
        var outfitBool = false
        ref.child("users").child(UID!).child("outfits").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            
            if value == nil {
                outfitBool = false
            } else {
            
                let dates = value?.allKeys as? [String]
                
                let date = Date()
                let calendar = Calendar.current
                let year = calendar.component(.year, from: date)
                let month = calendar.component(.month, from: date)
                let day = calendar.component(.day, from: date)
                
                let dateStr = "\(year)-\(month)-\(day)"
                if dates!.count > 0 {
                    for i in dates! {
                        if i == dateStr {
                            outfitBool = true
                        }
                    }
                }
                outfitBool = false
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        return outfitBool
    }
    
}
