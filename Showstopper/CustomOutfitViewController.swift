//
//  CustomOutfitViewController.swift
//  Showstopper
//
//  Created by Avinash Jain on 1/20/18.
//  Copyright © 2018 Avinash Jain. All rights reserved.
//

import UIKit
import ChameleonFramework

class OutfitClothingCollectionViewCell : UICollectionViewCell {
    
    @IBOutlet var clothingImageView: UIImageView!
}

class CustomOutfitViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet weak var topCollectionView: UICollectionView!
    @IBOutlet weak var botCollectionView: UICollectionView!
    @IBOutlet weak var shoeCollectionView: UICollectionView!
    
    var topImages = [UIImage(named: "shirt")]
    var botImages = [UIImage(named: "pants")]
    var shoeImages = [UIImage(named: "shoee")]
    
    var closet = User.currentUser.closet
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        User.currentUser.getClosetData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCollection), name: NSNotification.Name(rawValue: "load"), object: nil)
        
        self.view.backgroundColor = UIColor(gradientStyle: .topToBottom, withFrame: self.view.frame, andColors: [HexColor("#ee0979")!, HexColor("#ff6a00")!])
        topCollectionView.register(UINib(nibName: "OutfitClothingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "outfitphoto")
        botCollectionView.register(UINib(nibName: "OutfitClothingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "outfitphoto")
        shoeCollectionView.register(UINib(nibName: "OutfitClothingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "outfitphoto")
        // Do any additional setup after loading the view.
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            self.reloadCollection()
        })
    }

    @objc func reloadCollection() {
        topCollectionView.reloadData()
        botCollectionView.reloadData()
        shoeCollectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if closet.topClothing.count == 0 {
            return 0
        }
        
        switch (collectionView) {
        case self.topCollectionView:
            return closet.topClothing.count + 2
        case self.botCollectionView:
            return closet.botClothing.count + 2
        case self.shoeCollectionView:
            return closet.shoeClothing.count + 2
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "outfitphoto", for: indexPath) as! OutfitClothingCollectionViewCell
        var dataArr = [Clothing]()
        var initialImage = UIImage()
        switch (collectionView) {
        case self.topCollectionView:
            dataArr = closet.topClothing
            initialImage = #imageLiteral(resourceName: "shirt")
        case self.botCollectionView:
            dataArr = closet.botClothing
            initialImage = #imageLiteral(resourceName: "pants")
        case self.shoeCollectionView:
            dataArr = closet.shoeClothing
            initialImage = #imageLiteral(resourceName: "shoee")
        default:
            print("default")
        }
        
        if indexPath.row == 0 {
            cell.clothingImageView.image = initialImage
        } else if indexPath.row == dataArr.count+1 {
            return cell
        } else {
            cell.clothingImageView.image = dataArr[indexPath.row-1].img
            cell.clothingImageView.layer.cornerRadius = 10.0
            cell.clothingImageView.layer.borderColor = UIColor.white.cgColor
            cell.clothingImageView.layer.borderWidth = 2.0
        }
        return cell
        
        
        
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
