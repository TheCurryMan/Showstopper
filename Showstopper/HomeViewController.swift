//
//  HomeViewController.swift
//  Showstopper
//
//  Created by Avinash Jain on 1/20/18.
//  Copyright © 2018 Avinash Jain. All rights reserved.
//

import UIKit
import ChameleonFramework

class HomeViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var botImageView: UIImageView!
    @IBOutlet weak var shoeImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var addClothesButton: UIButton!
    @IBOutlet weak var updateOutfitButton: UIButton!
    
    var curUser = User.currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(gradientStyle: .topToBottom, withFrame: self.view.frame, andColors: [HexColor("#ee0979")!, HexColor("#ff6a00")!])
        
        addClothesButton.layer.cornerRadius = 10.0
        updateOutfitButton.layer.cornerRadius = 10.0
        // Do any additional setup after loading the view.
        topImageView.image = curUser.currentOutfit?.upperBody?.img
        botImageView.image = curUser.currentOutfit?.lowerBody?.img
        shoeImageView.image = curUser.currentOutfit?.shoes?.img
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addClothes(_ sender: Any) {
    }
    @IBAction func updateOutfit(_ sender: Any) {
    }
    
    

}
