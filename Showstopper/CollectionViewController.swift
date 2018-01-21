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
import Alamofire
import WebKit

class CustomCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var botImageView: UIImageView!
    @IBOutlet weak var shoeImageView: UIImageView!
    
}

class CollectionViewController: UIViewController, UICollectionViewDataSource {
    
    @IBOutlet weak var trendingTopImage: UIImageView!
    @IBOutlet weak var trendingBotImage: UIImageView!
    @IBOutlet weak var trendingShoeImage: UIImageView!
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var cu = User.currentUser
    var trendingOutfit = Outfit()
    var trendingURLs = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(cu.collection)
        
        self.view.backgroundColor = UIColor(gradientStyle: .topToBottom, withFrame: self.view.frame, andColors: [HexColor("#ee0979")!, HexColor("#ff6a00")!])
        
        self.collectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "outfit")
        
        //cu.collection = [cu.currentOutfit!, cu.currentOutfit!, cu.currentOutfit!, cu.currentOutfit!]
        
        // Do any additional setup after loading the view.
        
        getTrendingData(completion: {(b) in
            self.trendingTopImage.image = self.trendingOutfit.upperBody?.img
            self.trendingBotImage.image = self.trendingOutfit.lowerBody?.img
            self.trendingShoeImage.image = self.trendingOutfit.shoes?.img
        })
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
        cell.topImageView.layer.cornerRadius = 5.0
        cell.botImageView.image = of.lowerBody!.img
        cell.botImageView.layer.cornerRadius = 5.0
        cell.shoeImageView.image = of.shoes!.img
        cell.shoeImageView.layer.cornerRadius = 5.0
        return cell
        
    }
    
    @IBAction func dismissView(_ sender: Any) {
        if webView.isHidden == false {
            webView.isHidden = true
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    func getTrendingData(completion: @escaping (Bool) -> Void) {
        let requestString = "http://mysterious-shelf-30539.herokuapp.com/findhottest"
        
        Alamofire.request(requestString, method: .get, parameters: nil, encoding: URLEncoding(destination: .queryString), headers: nil).responseJSON { (response) in
            
            guard let status = response.response?.statusCode else {
                print("unable to get status code")
                return
            }
            if status != 200   {
                print("Staus: \(status)")
            }
            
            guard let result = response.result.value, let json = result as? NSDictionary else {
                print("failed to get the response")
                return
            }
            
            if let clothingIds = json["clothing_id"] as? [String:String] {
                User.currentUser.getClothingData(i: clothingIds["top"]!, completion:{(top) in
                    User.currentUser.getClothingData(i: clothingIds["bot"]!, completion: {(bot) in
                        User.currentUser.getClothingData(i: clothingIds["sho"]!, completion: {(shoe) in
                            self.trendingOutfit = Outfit(upperBody: top, lowerBody: bot, shoes: shoe)
                            var urls = json["clothing_url"] as? [String:String]
                            for url in (urls?.keys)! {
                                self.trendingURLs.append(urls![url]!)
                            }
                            completion(true)
                        })
                    })
                })
            }
        }
    }
    
    @IBAction func topButtonStore(_ sender: Any) {
        let myURL = URL(string: self.trendingURLs[0])
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        webView.isHidden = false
    }
    
    @IBAction func botButtonStore(_ sender: Any) {
        let myURL = URL(string: self.trendingURLs[1])
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
         webView.isHidden = false
    }
    
    @IBAction func shoeButtonStore(_ sender: Any) {
        let myURL = URL(string: self.trendingURLs[2])
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
         webView.isHidden = false
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
