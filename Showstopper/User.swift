//
//  User.swift
//  Showstopper
//
//  Created by Ritik Batra on 1/20/18.
//  Copyright © 2018 Avinash Jain. All rights reserved.
//

import Foundation
import Firebase

class User {
    var name : String?
    var UID : String?
    var playerID : String?
    
    static var currentUser = User()
    let ref : DatabaseReference = Database.database().reference()
    private init() {
    }
    
    func setUID() {
        UID = Auth.auth().currentUser?.uid
    }
    
    func setUpUser() {
        UID = Auth.auth().currentUser?.uid
        ref.child("users").child(UID!).observeSingleEvent(of: .value, with:
            { (snapshot) in
                let value = snapshot.value as? NSDictionary
                self.name = value?["name"] as? String
                self.playerID = value?["playerID"] as? String
                
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    

}
