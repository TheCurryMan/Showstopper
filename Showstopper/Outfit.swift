//
//  Outfit.swift
//  Showstopper
//
//  Created by Avinash Jain on 1/20/18.
//  Copyright © 2018 Avinash Jain. All rights reserved.
//

import Foundation

struct Outfit {
    var upperBody : Clothing?
    var lowerBody : Clothing?
    var shoes : Clothing?
    
    func returnOutfitData() -> [String:String] {
        return ["topID":(upperBody?.id!)!, "botID":(lowerBody?.id!)!, "shoID":(shoes?.id!)!]
    }
    
    
    
}
