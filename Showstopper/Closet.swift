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
    
    var topClothing = [Clothing]()
    var botClothing = [Clothing]()
    var shoeClothing = [Clothing]()
    var gotData = false
    
    let ref : DatabaseReference = Database.database().reference()
    
    public init() {
    }
    
    func setIds(top: [String], bot:[String], shoe:[String]) {
        self.topIds = top
        self.botIds = bot
        self.shoeIds = shoe
        
        self.getImageData()
    }
    
    func getImageData() {
        
        ref.child("items").observe(.value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as! [String:Any]
            for i in self.topIds! {
                var data = value[i] as! [String: String]
                var clothingItem = Clothing(cat: data["cat"]! as! String, color: data["color"]! as! String, id: i, desc: data["description"]! as! String, tag: data["tag"]! as! String)
                self.topClothing.append(clothingItem)
                self.topClothing[(self.topClothing.count)-1].addImage()
            }
            
            for i in self.botIds! {
                var data = value[i] as! [String: String]
                var clothingItem = Clothing(cat: data["cat"]! as! String, color: data["color"]! as! String, id: i, desc: data["description"]! as! String, tag: data["tag"]! as! String)
                self.botClothing.append(clothingItem)
                self.botClothing[(self.botClothing.count)-1].addImage()
            }
            
            for i in self.shoeIds! {
                var data = value[i] as! [String: String]
                var clothingItem = Clothing(cat: data["cat"]! as! String, color: data["color"]! as! String, id: i, desc: data["description"]! as! String, tag: data["tag"]! as! String)
                self.shoeClothing.append(clothingItem)
                self.shoeClothing[(self.shoeClothing.count)-1].addImage()
            }
        })
        
    }
        /*
        for id in self.topIds! {
            ref.child("items").child(id).observe(.value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as! [String:String]
                var clothingItem = Clothing(cat: value["cat"]!, color: value["color"]!, id: id, desc: value["description"]!, tag: value["tag"]!)
                clothingItem.addImage()
                self.topClothing?.append(clothingItem)
     
            })
            
        }
        
        for id in self.botIds! {
            ref.child("items").child(id).observe(.value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as! [String:String]
                var clothingItem = Clothing(cat: value["cat"]!, color: value["color"]!, id: id, desc: value["description"]!, tag: value["tag"]!)
                clothingItem.addImage()
                self.botClothing?.append(clothingItem)
                
            })
            
        }
        
        for id in self.shoeIds! {
            ref.child("items").child(id).observe(.value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as! [String:String]
                var clothingItem = Clothing(cat: value["cat"]!, color: value["color"]!, id: id, desc: value["description"]!, tag: value["tag"]!)
                clothingItem.addImage()
                self.shoeClothing?.append(clothingItem)
            })
        } */
        
    
}
