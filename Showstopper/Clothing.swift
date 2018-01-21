//
//  Clothing.swift
//  Showstopper
//
//  Created by Avinash Jain on 1/20/18.
//  Copyright © 2018 Avinash Jain. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Clothing {
    var cat: String?
    var color: String?
    var id: String?
    var desc: String?
    var tag: String?
    var img: UIImage!

    let ref: DatabaseReference = Database.database().reference()
    let storageRef = Storage.storage().reference()
    init() {
        
    }
    
    init(cat: String, color: String, id: String, desc: String, tag: String) {
        self.cat = cat
        self.color = color
        self.id = id
        self.desc = desc
        self.tag = tag
    }
    
    func addImage(completion: @escaping (Bool) -> Void) {
        print("DOWNLOADING IMAGE")
        let imageURL = "\(User.currentUser.UID!)" + "/" + self.id! + ".jpeg"
        let imageRef = storageRef.child(imageURL)
        imageRef.downloadURL { url, error in
            if let error = error {
                print("WE HAVE AN ERROR")
                completion(false)
                // Handle any errors
            } else {
                let data = try! Data(contentsOf: url!)
                let image = UIImage(data: data as Data)
                self.img = image!
                completion(true)
            }
        }
    }
}
