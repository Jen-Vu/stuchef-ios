//
//  AddReviewViewController.swift
//  StuChef
//
//  Created by Tom Fullylove on 26/04/2019.
//  Copyright © 2019 Tom Fullylove. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

class AddReviewViewController : UIViewController {
    
    var ref : DatabaseReference!
    var order : Order?
    @IBOutlet weak var pic: UIImageView!
    @IBOutlet weak var star1: UIButton!
    @IBOutlet weak var star2: UIButton!
    @IBOutlet weak var star3: UIButton!
    @IBOutlet weak var star4: UIButton!
    @IBOutlet weak var star5: UIButton!
    @IBOutlet weak var reviewText: UITextView!
    var starRating = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let reference = storageRef.child("dish-imgs/\(order!.dish).png")
        let place = UIImage(named: "Logo.jpg")
        pic.sd_setImage(with: reference, placeholderImage: place)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @IBAction func rating(_ sender: UIButton) {
        switch sender {
        case star1:
            if starRating == 1{
                starRating = 0
                star1.setImage(UIImage(named : "stargrey"), for : [])
                star2.setImage(UIImage(named : "stargrey"), for : [])
                star3.setImage(UIImage(named : "stargrey"), for : [])
                star4.setImage(UIImage(named : "stargrey"), for : [])
                star5.setImage(UIImage(named : "stargrey"), for : [])
            }else{
                starRating = 1
                star1.setImage(UIImage(named : "star"), for : [])
                star2.setImage(UIImage(named : "stargrey"), for : [])
                star3.setImage(UIImage(named : "stargrey"), for : [])
                star4.setImage(UIImage(named : "stargrey"), for : [])
                star5.setImage(UIImage(named : "stargrey"), for : [])
            }
        case star2:
            starRating = 2
            star1.setImage(UIImage(named : "star"), for : [])
            star2.setImage(UIImage(named : "star"), for : [])
            star3.setImage(UIImage(named : "stargrey"), for : [])
            star4.setImage(UIImage(named : "stargrey"), for : [])
            star5.setImage(UIImage(named : "stargrey"), for : [])
        case star3:
            starRating = 3
            star1.setImage(UIImage(named : "star"), for : [])
            star2.setImage(UIImage(named : "star"), for : [])
            star3.setImage(UIImage(named : "star"), for : [])
            star4.setImage(UIImage(named : "stargrey"), for : [])
            star5.setImage(UIImage(named : "stargrey"), for : [])
        case star4:
            starRating = 4
            star1.setImage(UIImage(named : "star"), for : [])
            star2.setImage(UIImage(named : "star"), for : [])
            star3.setImage(UIImage(named : "star"), for : [])
            star4.setImage(UIImage(named : "star"), for : [])
            star5.setImage(UIImage(named : "stargrey"), for : [])
        case star5:
            starRating = 5
            star1.setImage(UIImage(named : "star"), for : [])
            star2.setImage(UIImage(named : "star"), for : [])
            star3.setImage(UIImage(named : "star"), for : [])
            star4.setImage(UIImage(named : "star"), for : [])
            star5.setImage(UIImage(named : "star"), for : [])
        default:
            break;
        }
    }
    @IBAction func submit(_ sender: Any) {
        self.ref = Database.database().reference()
        let revData = ["buyer": AppVariables.uid, "seller": order!.seller, "dish": order!.dish, "text": reviewText.text, "rating": starRating] as [String : Any]
        let id = NSUUID().uuidString
        self.ref.child("review").child(id).setValue(revData)
        self.performSegue(withIdentifier: "showTab", sender: nil)
    }
}
