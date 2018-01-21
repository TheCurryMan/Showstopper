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
    var ref : DatabaseReference = Database.database().reference()
    
    private init() {
    }
    
    func setUID() {
        UID = Auth.auth().currentUser?.uid
    }
    
    func setUpUser(completion: @escaping (Bool) -> Void) {
        UID = Auth.auth().currentUser?.uid
        
        ref = Database.database().reference()
        ref.child("users").child(UID!).observe(.value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            self.name = value?["name"] as? String
            
            //self.location = (value?["lat"] as! Float, value?["long"] as! Float)
            //self.closet = value?["closet"]xc
            
        completion(true)
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getClosetData() {
        ref = Database.database().reference()
        ref.child("users").child(UID!).child("closet").observe(.value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            self.closet.setIds(top: value?["top"] as! [String], bot: value?["bot"] as! [String], shoe: value?["sho"] as! [String])
            
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func checkCurrentOutfit(completion: @escaping (Bool) -> Void){
        print(UID!)
        
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let dateStr = "\(year)-\(month)-\(day)"
        
        ref.child("users").child(UID!).child("outfits").observe(.value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            if let outfit = value?["\(dateStr)"] as? [String: String]{
                
                User.currentUser.getClothingData(i: outfit["topID"]!, completion:{(top) in
                    User.currentUser.getClothingData(i: outfit["botID"]!, completion: {(bot) in
                        User.currentUser.getClothingData(i: outfit["shoID"]!, completion: {(shoe) in
                            User.currentUser.currentOutfit = Outfit(upperBody: top, lowerBody: bot, shoes: shoe)
                            completion(true)
                        })
                        
                    })
                    
                })
                
                
            } else {
                completion(false)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getClothingData(i: String, completion: @escaping (Clothing) -> Void) {
        ref.child("items").observe(.value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as! [String:Any]
            var data = value[i] as! [String: String]
            var clothingItem = Clothing(cat: data["cat"]! as! String, color: data["color"]! as! String, id: i, desc: data["description"]! as! String, tag: data["tag"]! as! String)
            clothingItem.addImage()
            completion(clothingItem)
        }){ (error) in
            print(error.localizedDescription)
        }
    }
    
}
