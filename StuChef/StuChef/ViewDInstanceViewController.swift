//
//  ViewDInstanceViewController.swift
//  StuChef
//
//  Created by Tom Fullylove on 08/04/2019.
//  Copyright © 2019 Tom Fullylove. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseUI

class ViewDInstanceViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var ref : DatabaseReference!
    var instance: DishInstance?
    var pickerView : UIPickerView!
    var pickerData = [String]()
    var pickerString = "1"
    var reviews = [Review]()
    @IBOutlet weak var pic: UIImageView!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var descText: UITextView!
    @IBOutlet weak var cuisineLabel: UILabel!
    @IBOutlet weak var revLabel: UILabel!
    @IBOutlet weak var dietLabel: UILabel!
    @IBOutlet weak var allerLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        var starRating : Float = 0
        var revNum : Float = 0
        var dietString : String = ""
        var allerString : String = ""
        ref = Database.database().reference()
        ref.child("dish").child(instance!.dish).observeSingleEvent(of: .value, with: { (snapshot) in
            let dishSnap = snapshot.value as! [String : Any]
            self.title = dishSnap["title"] as? String
            self.descText.text = dishSnap["description"] as? String
            self.cuisineLabel.text = dishSnap["cuisine"] as? String
            dietString = dishSnap["diet"] as! String
            self.dietLabel.text = dietString
            let allerArray = dishSnap["allergens"] as! [String]
            for aller in allerArray {
                if(aller == allerArray[0]){
                    allerString += aller
                }else{
                    allerString += ", \(aller)"
                }
            }
            self.allerLabel.text = allerString
            self.ref.child("review").queryOrdered(byChild : "seller").queryEqual(toValue : dishSnap["user"] as? String).observeSingleEvent(of : .value, with : { (snapshot) in
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let revSnap = snap.value as! [String : Any]
                    let review = Review()
                    review.key = snap.key
                    review.dish = revSnap["dish"] as! String
                    review.rating = revSnap["rating"] as! Float
                    review.txt = revSnap["text"] as! String
                    self.reviews.append(review)
                    starRating += revSnap["rating"] as! Float
                    revNum += 1
                }
                if(revNum > 0){
                    starRating = starRating/revNum
                    let starImage = UIImage(named: "star.jpg")
                    switch starRating {
                    case 0.7...1.7:
                        self.star1.image = starImage
                    case 1.7...2.7:
                        self.star1.image = starImage
                        self.star2.image = starImage
                    case 2.7...3.7:
                        self.star1.image = starImage
                        self.star2.image = starImage
                        self.star3.image = starImage
                    case 3.7...4.7:
                        self.star1.image = starImage
                        self.star2.image = starImage
                        self.star3.image = starImage
                        self.star4.image = starImage
                    case 4.7...5:
                        self.star1.image = starImage
                        self.star2.image = starImage
                        self.star3.image = starImage
                        self.star4.image = starImage
                        self.star5.image = starImage
                    default:
                        break;
                    }
                    self.revLabel.text = "(\(Int(revNum)))"
                }
                self.reviewTable.reloadData()
            })
        })
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let reference = storageRef.child("dish-imgs/\(instance!.dish).png")
        let place = UIImage(named: "Logo.jpg")
        pic.sd_setImage(with: reference, placeholderImage: place)
        priceLabel.text = "£\(String(instance!.price))0"
    }
    @IBOutlet weak var reviewTable: UITableView!{
        didSet {
            reviewTable.dataSource = self
        }
    }
    @IBOutlet weak var infoToReview: UISegmentedControl!
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch infoToReview.selectedSegmentIndex {
        case 0:
            infoView.isHidden = false
            reviewTable.isHidden = true
            break;
        case 1:
            infoView.isHidden = true
            reviewTable.isHidden = false
            break;
        default:
            break;
        }
    }
    @IBAction func back(_ sender: UIBarButtonItem) {
        dismiss(animated : true, completion : nil)
    }
    @IBAction func order(_ sender: UIBarButtonItem) {
        for i in 1...instance!.remain {
            self.pickerData.append(String(i))
        }
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YYYY"
        let orderDate = formatter.string(from: date)
        let vc = UIViewController()
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        vc.preferredContentSize = CGSize(width: screenWidth,height: 120)
        pickerView = UIPickerView(frame: CGRect(x: -12, y: 0, width: screenWidth, height: 100))
        pickerView.delegate = self
        pickerView.dataSource = self
        vc.view.addSubview(pickerView)
        let editRadiusAlert = UIAlertController(title: "Number of portions", message: "", preferredStyle: .actionSheet)
        editRadiusAlert.setValue(vc, forKey: "contentViewController")
        editRadiusAlert.addAction(UIAlertAction(title: "Confirm Order", style: .default, handler: {(action:UIAlertAction!) in
            self.ref = Database.database().reference()
            let orderData = ["buyer" : AppVariables.uid, "complete" : false, "date" : orderDate, "dish-instance": self.instance!.key, "quantity" : Int(self.pickerString)!, "ready" : false, "seller" : self.instance!.seller] as [String : Any]
            let id = NSUUID().uuidString
            self.ref.child("order").child(id).setValue(orderData)
            let taken = self.instance!.taken + Int(self.pickerString)!
            self.ref.child("dish-instance/\(self.instance!.key)/quantity/0").setValue(taken)
            self.dismiss(animated : true, completion : nil)
        }))
        editRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(editRadiusAlert, animated: true)
    
    }
    func numberOfSectionsInTableView(tableView : UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView : UITableView, numberOfRowsInSection section : Int) -> Int {
        var count : Int! = 0
        count = reviews.count
        return count!
    }
    func tableView(_ tableView : UITableView, cellForRowAt indexPath : IndexPath) -> UITableViewCell {
        let cellIdentifier = "review"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ReviewDishTableViewCell  else {
            fatalError()
        }
        ref.child("dish").child(reviews[indexPath.row].dish).observeSingleEvent(of: .value, with: { (snapshot) in
            let dishSnap = snapshot.value as! [String : Any]
            cell.titleLabel.text = dishSnap["title"] as? String
        })
        cell.txtLabel.text = reviews[indexPath.row].txt
        let starImage = UIImage(named: "star.jpg")
        switch reviews[indexPath.row].rating {
        case 1:
            cell.star1.image = starImage
        case 2:
            cell.star1.image = starImage
            cell.star2.image = starImage
        case 3:
            cell.star1.image = starImage
            cell.star2.image = starImage
            cell.star3.image = starImage
        case 4:
            cell.star1.image = starImage
            cell.star2.image = starImage
            cell.star3.image = starImage
            cell.star4.image = starImage
        case 5:
            cell.star1.image = starImage
            cell.star2.image = starImage
            cell.star3.image = starImage
            cell.star4.image = starImage
            cell.star5.image = starImage
        default:
            break;
        }
        return cell
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerString = pickerData[row]
    }
}
