//
//  Closet.swift
//  Showstopper
//
//  Created by Avinash Jain on 1/20/18.
//  Copyright © 2018 Avinash Jain. All rights reserved.
//

import Foundation
import Firebase

class Closet {
    var topIds : [String]?
    var botIds : [String]?
    var shoeIds : [String]?
    
    var topData : [String:String]?
    var botData : [String:String]?
    var shoeData : [String:String]?
    
    public init() {
    }
    
    func setIds(top: [String], bot:[String], shoe:[String]) {
        self.topIds = top
        self.botIds = bot
        self.shoeIds = shoe
    }

    func getCurrentOutfitImages() {
        
    }
    
}
