//
//  ViewOrderViewController.swift
//  StuChef
//
//  Created by Tom Fullylove on 08/04/2019.
//  Copyright © 2019 Tom Fullylove. All rights reserved.
//
import UIKit
import MapKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseUI

class ViewOrderViewController : UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var order: Order?
    var ref : DatabaseReference!
    @IBOutlet weak var pic: UIImageView!
    @IBOutlet weak var portionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dateOLabel: UILabel!
    @IBOutlet weak var dateRLabel: UILabel!
    @IBOutlet weak var readyLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collected: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        ref.child("dish-instance").child(order!.dishI).observeSingleEvent(of: .value, with: { (snapshot) in
            let dishISnap = snapshot.value as! [String : Any]
            self.order!.dish = dishISnap["dish"] as! String
            let date = dishISnap["time"] as! [String]
            self.dateRLabel.text = "\(date[0]) \(date[1])"
            let price = Float(self.order!.quantity) * (dishISnap["price"] as! Float)
            self.priceLabel.text = "£\(price)0"
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let reference = storageRef.child("dish-imgs/\(self.order!.dish).png")
            let place = UIImage(named: "Logo.jpg")
            self.pic.sd_setImage(with: reference, placeholderImage: place)
            self.ref.child("dish").child(self.order!.dish).observeSingleEvent(of: .value, with: { (snapshot) in
                let dishSnap = snapshot.value as! [String : Any]
                self.title = dishSnap["title"] as? String
            })
            self.ref.child("user").child(dishISnap["user"] as! String).observeSingleEvent(of: .value, with: { (snapshot) in
                let userSnap = snapshot.value as! [String : Any]
                let addressArray = userSnap["address"] as! [String]
                let address = "\(addressArray[0]) \(addressArray[1]) \(addressArray[2]) "
                let geocoder = CLGeocoder()
                geocoder.geocodeAddressString(address) { (placemarks, error) in
                    if let placemarks = placemarks {
                        if placemarks.count != 0 {
                            let annotation = MKPlacemark(placemark: placemarks.first!)
                            self.mapView.addAnnotation(annotation)
                            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
                        }
                    }
                }
            })
        })
        if order!.ready {
            self.readyLabel.text = "Your order is ready to collect"
        }else{
            self.readyLabel.text = "Your order is not ready yet"
        }
        var portion : String = ""
        if(order!.quantity == 1){
            portion = "portion"
        }else{
            portion = "portions"
        }
        portionLabel.text = " \(order!.quantity) \(portion)"
        dateOLabel.text = "\(order!.date)"
        
        if(order!.ready){
            collected.isEnabled = true
        }
    }
    func showAnnotations(_ annotations: [AnyObject]!,
                         animated: Bool){
    }
    @IBAction func collected(_ sender: Any) {
        self.ref = Database.database().reference()
        self.ref.child("order/\(order!.key)/complete").setValue(true)
        let alert = UIAlertController(title: "Order Complete", message: "Leaving a review can help the seller", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "No Thanks", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Leave a Review", style: .cancel, handler: {(action:UIAlertAction!) in
            self.performSegue(withIdentifier: "writeReview", sender: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func back(_ sender: Any) {
        dismiss(animated : true, completion : nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if(segue.identifier == "writeReview"){
            let review = segue.destination as? AddReviewViewController
            review!.order = order!
        }
    }
}
