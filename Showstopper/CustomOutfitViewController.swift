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
    var shoeImages = [UIImage(named: "shoe")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(gradientStyle: .topToBottom, withFrame: self.view.frame, andColors: [HexColor("#ee0979")!, HexColor("#ff6a00")!])
        topCollectionView.register(UINib(nibName: "OutfitClothingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "outfitphoto")
        botCollectionView.register(UINib(nibName: "OutfitClothingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "outfitphoto")
        shoeCollectionView.register(UINib(nibName: "OutfitClothingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "outfitphoto")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch (collectionView) {
        case self.topCollectionView:
            return topImages.count
        case self.botCollectionView:
            return botImages.count
        case self.shoeCollectionView:
            return shoeImages.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "outfitphoto", for: indexPath) as! OutfitClothingCollectionViewCell
        var dataArr = [UIImage(named:"shirt")]
        switch (collectionView) {
        case self.topCollectionView:
            dataArr = topImages
        case self.botCollectionView:
            dataArr = botImages
        case self.shoeCollectionView:
            dataArr = shoeImages
        default:
            print("default")
        }
        
        cell.clothingImageView.image = dataArr[indexPath.row]
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
