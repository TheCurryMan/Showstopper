//
//  CustomOutfitViewController.swift
//  Showstopper
//
//  Created by Avinash Jain on 1/20/18.
//  Copyright © 2018 Avinash Jain. All rights reserved.
//

import UIKit
import ChameleonFramework
import Firebase

class OutfitClothingCollectionViewCell : UICollectionViewCell {
    
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet var clothingImageView: UIImageView!
}

class CustomOutfitViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var saveOutfitButton: UIButton!
    @IBOutlet weak var topCollectionView: UICollectionView!
    @IBOutlet weak var botCollectionView: UICollectionView!
    @IBOutlet weak var shoeCollectionView: UICollectionView!
    
    var topImages = [UIImage(named: "shirt")]
    var botImages = [UIImage(named: "pants")]
    var shoeImages = [UIImage(named: "shoee")]
    var tappedClothes = [Clothing]()
    
    var closet = User.currentUser.closet
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        saveOutfitButton.layer.cornerRadius = 10.0
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
            cell.tag = 0
        } else if indexPath.row == dataArr.count+1 {
            cell.tag = 0
            return cell
        } else {
            cell.tag = 1
            cell.clothingImageView.image = dataArr[indexPath.row-1].img
            cell.clothingImageView.layer.cornerRadius = 10.0
            cell.clothingImageView.layer.borderColor = UIColor.white.cgColor
            cell.clothingImageView.layer.borderWidth = 2.0
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("tapped")
        let cell = collectionView.cellForItem(at: indexPath) as! OutfitClothingCollectionViewCell
        if (cell.tag == 1) {
            if cell.selectedImageView.isHidden == false {
                cell.selectedImageView.isHidden = true
                var index = Int()
                for (i,c) in tappedClothes.enumerated() {
                    if c.img == cell.selectedImageView.image {
                        index = i
                    }
                }
                tappedClothes.remove(at: index)
            } else {
                cell.selectedImageView.isHidden = false
                switch (collectionView) {
                case topCollectionView:
                    tappedClothes.append(closet.topClothing[indexPath.row-1])
                case botCollectionView:
                    tappedClothes.append(closet.botClothing[indexPath.row-1])
                case shoeCollectionView:
                    tappedClothes.append(closet.shoeClothing[indexPath.row-1])
                default:
                    print("Error")
                }
            }
        }
    }
    
    @IBAction func saveOutfit(_ sender: Any) {
        print(tappedClothes)
        var (up, low, sho) = (Clothing(), Clothing(), Clothing())
        for c in tappedClothes {
            if c.cat == "top" {
                up = c
            } else if c.cat == "bot" {
                low = c
            } else {
                sho = c
            }
        }
        User.currentUser.currentOutfit = Outfit(upperBody: up, lowerBody: low, shoes: sho)
        saveOutfitToFirebase()
    }
    
    func saveOutfitToFirebase() {
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let dateStr = "\(year)-\(month)-\(day)"
        
        let ref : DatabaseReference! = Database.database().reference()
        ref.child("users").child("\(User.currentUser.UID!)").child("outfits").updateChildValues(["\(dateStr)":User.currentUser.currentOutfit?.returnOutfitData()])
        
        
        
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
