//
//  ViewSOrderViewController.swift
//  StuChef
//
//  Created by Tom Fullylove on 09/04/2019.
//  Copyright © 2019 Tom Fullylove. All rights reserved.
//
import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseUI

class ViewSOrderViewController : UIViewController {
    var order: Order?
    var ref : DatabaseReference!
    var instDate = ""
    @IBOutlet weak var pic: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        ref.child("dish-instance").child(order!.dishI).observeSingleEvent(of: .value, with: { (snapshot) in
            let instSnap = snapshot.value as! [String : Any]
            self.order!.dish = instSnap["dish"] as! String
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let reference = storageRef.child("dish-imgs/\(self.order!.dish).png")
            let place = UIImage(named: "Logo.jpg")
            let date = instSnap["time"] as! [String]
            self.instDate = date[1]
            self.pic.sd_setImage(with: reference, placeholderImage: place)
            self.ref.child("dish").child(self.order!.dish).observeSingleEvent(of: .value, with: { (snapshot) in
                let dishSnap = snapshot.value as! [String : Any]
                self.title = dishSnap["title"] as? String
            })
        })
    }
    @IBAction func markReady(_ sender: Any) {
        let calendar = NSCalendar.current
        let startDate = Date()
        let date = calendar.date(byAdding: .day, value: 0, to: startDate)!
        let fmt = DateFormatter()
        fmt.dateFormat = "dd/MM/yyyy"
        let dateString = fmt.string(from: date)
        var error = false
        if dateString != instDate {
            error = true
        }
        if error {
            let alert = UIAlertController(title: "Unsuccessful", message: "Order can only be marked complete on the date it's scheduled", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            self.ref = Database.database().reference()
            self.ref.child("order/\(order!.key)/ready").setValue(true)
            self.dismiss(animated : true, completion : nil)
        }
    }
    @IBAction func back(_ sender: Any) {
        dismiss(animated : true, completion : nil)
    }
}
