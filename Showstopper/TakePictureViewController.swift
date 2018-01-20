//
//  TakePictureViewController.swift
//  Showstopper
//
//  Created by Avinash Jain on 1/20/18.
//  Copyright © 2018 Avinash Jain. All rights reserved.
//

import UIKit
import ChameleonFramework
import Firebase

class TakePictureCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var clothImageView: UIImageView!
    @IBOutlet var testLabel: UILabel!
    
}

class TakePictureViewController: UIViewController, UICollectionViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDelegate {

    var images = [UIImage]()
    var imagePicker = UIImagePickerController()
    let storageRef = Storage.storage().reference()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        UINib(nibName: "TakePictureCollectionViewCell", bundle: nil)
        self.collectionView.register(UINib(nibName: "TakePictureCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "takephoto")
        self.view.backgroundColor = UIColor(gradientStyle: .topToBottom, withFrame: self.view.frame, andColors: [HexColor("#ee0979")!, HexColor("#ff6a00")!])

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            images.append(pickedImage.resizeImage(500.0, opaque: true))
            collectionView.reloadData()
            imagePicker.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func finishPhotos(_ sender: Any) {
        let photoRef = storageRef.child("\(User.currentUser.UID!)")
        for img in images {
            let timestamp = NSDate().timeIntervalSince1970
            let photoIDRef = photoRef.child("\(timestamp).png")
            let imageData = UIImagePNGRepresentation(img)
            
            let uploadTask = photoIDRef.putData(imageData!, metadata: nil) { metadata, error in
                if let error = error {
                    print(error)
                }
            }
        }
        performSegue(withIdentifier: "createOutfit", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell:TakePictureCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "takephoto", for: indexPath) as! TakePictureCollectionViewCell
        cell.backgroundColor = UIColor.blue
        //let imageV = UIImageView(image: images[indexPath.row])
        cell.clothImageView.image = images[indexPath.row]
        cell.clothImageView.layer.borderColor = UIColor.white.cgColor
        cell.clothImageView.layer.borderWidth = 3.0
        //cell.clothImageView.layer.cornerRadius = 5.0
        //cell.testLabel.text = "asd"
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        images.remove(at: indexPath.row)
        collectionView.reloadData()
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

extension UIImage {
    func resizeImage(_ dimension: CGFloat, opaque: Bool, contentMode: UIViewContentMode = .scaleAspectFit) -> UIImage {
        var width: CGFloat
        var height: CGFloat
        var newImage: UIImage
        
        let size = self.size
        let aspectRatio =  size.width/size.height
        
        switch contentMode {
        case .scaleAspectFit:
            if aspectRatio > 1 {                            // Landscape image
                width = dimension
                height = dimension / aspectRatio
            } else {                                        // Portrait image
                height = dimension
                width = dimension * aspectRatio
            }
            
        default:
            fatalError("UIIMage.resizeToFit(): FATAL: Unimplemented ContentMode")
        }
        
        if #available(iOS 10.0, *) {
            let renderFormat = UIGraphicsImageRendererFormat.default()
            renderFormat.opaque = opaque
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height), format: renderFormat)
            newImage = renderer.image {
                (context) in
                self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), opaque, 0)
            self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
            newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }
        
        return newImage
    }
}
