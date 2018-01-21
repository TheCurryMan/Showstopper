//
//  CollectionViewController.swift
//  Showstopper
//
//  Created by Avinash Jain on 1/21/18.
//  Copyright © 2018 Avinash Jain. All rights reserved.
//

import UIKit
import ChameleonFramework
import Firebase

class CustomCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var botImageView: UIImageView!
    @IBOutlet weak var shoeImageView: UIImageView!
    
}

class CollectionViewController: UIViewController, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var cu = User.currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(gradientStyle: .topToBottom, withFrame: self.view.frame, andColors: [HexColor("#ee0979")!, HexColor("#ff6a00")!])
        
        self.collectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "outfit")
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return User.currentUser.collection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "outfit", for: indexPath) as! CustomCollectionViewCell
        let of = cu.collection[indexPath.row]
        cell.topImageView.image = of.upperBody!.img
        cell.botImageView.image = of.lowerBody!.img
        cell.shoeImageView.image = of.shoes!.img
        return cell
        
    }
    
    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
