//
//  SignUpViewController.swift
//  Showstopper
//
//  Created by Avinash Jain on 1/20/18.
//  Copyright © 2018 Avinash Jain. All rights reserved.
//


import UIKit
import ChameleonFramework
import Firebase
import SwiftLocation

class SignUpViewController: UIViewController {

    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(gradientStyle: .topToBottom, withFrame: self.view.frame, andColors: [HexColor("#ee0979")!, HexColor("#ff6a00")!])
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if Auth.auth().currentUser != nil {
            
            User.currentUser.setUpUser(completion: {(b) in
                
                User.currentUser.checkCurrentOutfit(completion: {(hasCurrentOutfit) in
                    print("YUH YUH YUH")
                 
                    if hasCurrentOutfit {
                        self.performSegue(withIdentifier: "signuptoloading", sender: nil)
                    } else {
                        self.performSegue(withIdentifier: "signin", sender: nil)
                    }
                    
                })
            })
           
            
        } else {
            print("user is NOT signed in")
            // ...
        }
        
    }
    
    @IBAction func signUpUser(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
            if error == nil {
                User.currentUser.setUID()
                let ref : DatabaseReference! = Database.database().reference()
                ref.child("users").child(user!.uid).updateChildValues(["name": self.firstNameField.text!])
                self.performSegue(withIdentifier: "signin", sender: self)
            }
        }
    }
    
    @IBAction func tappedScreen(_ sender: Any) {
        print("tapped")
        self.emailField.resignFirstResponder()
        self.passwordField.resignFirstResponder()
        self.firstNameField.resignFirstResponder()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
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
