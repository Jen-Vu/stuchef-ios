//
//  MainViewController.swift
//  StuChef
//
//  Created by Tom Fullylove on 20/10/2018.
//  Copyright © 2018 Tom Fullylove. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseUI
import FirebaseAuth

class MainViewController : UIViewController , UITableViewDelegate, UITableViewDataSource, FUIAuthDelegate {
    
    var ref : DatabaseReference!
    var cells = [[TableCell]]()
    var cells1 = [TableCell]()
    var sections = ["All Dishes"]
    var refine = AppVariables.refine
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.cells1 = []
        self.cells = []
        refine = AppVariables.refine
        getContent()
    } 
    
    func getContent(){
        ref = Database.database().reference()
        self.ref.child("dish-instance").queryOrdered(byChild : "available").queryEqual(toValue : true).observeSingleEvent(of : .value, with : { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let schedSnap = snap.value as! [String : Any]
                let remain = schedSnap["quantity"] as! [Int]
                let cell = TableCell()
                cell.taken = remain[1] - remain[0]
                cell.remain = remain[0]
                cell.key = snap.key
                cell.dish = schedSnap["dish"] as! String
                cell.price = schedSnap["price"] as! Float
                cell.type = "instance"
                cell.seller = schedSnap["user"] as! String
                let date = schedSnap["time"] as! [String]
                cell.date = "\(date[1])"
                if self.refine.refine{
                    var match = true
                    let date = schedSnap["time"] as! [String]
                    if cell.price < self.refine.price[0] || cell.price > self.refine.price[1]{
                        match = false
                    }
                    if date[1] != self.refine.date {
                        if self.refine.date != "Any"{
                            match = false
                        }
                    }
                    if match {
                        self.ref.child("dish").child(cell.dish).observeSingleEvent(of: .value, with: { (snapshot) in
                            let dishSnap = snapshot.value as! [String : Any]
                            if dishSnap["diet"] as! String != self.refine.diet{
                                if self.refine.diet != "Any"{
                                    match = false
                                }
                            }
                            if dishSnap["cuisine"] as! String != self.refine.cuisine {
                                if self.refine.cuisine != "Any"{
                                    match = false
                                }
                            }
                            let allerArray = dishSnap["allergens"] as! [String]
                            let alerSet = Set(allerArray + self.refine.allergens)
                            if(alerSet.count != (allerArray.count + self.refine.allergens.count)){
                                match = false
                            }
                            if match{
                                var starRatings : Float = 0
                                var revNums : Float = 0
                                self.ref.child("review").queryOrdered(byChild : "seller").queryEqual(toValue : dishSnap["user"] as? String).observeSingleEvent(of : .value, with : { (snapshot) in
                                    for child in snapshot.children {
                                        let snap = child as! DataSnapshot
                                        let revSnap = snap.value as! [String : Any]
                                        starRatings += revSnap["rating"] as! Float
                                        revNums += 1
                                    }
                                    if(revNums > 0){
                                        starRatings = starRatings/revNums
                                    }else{
                                        starRatings = 0
                                    }
                                    if starRatings < self.refine.rating {
                                        match = false
                                    }
                                    if match {
                                        self.cells1.append(cell)
                                        self.cells = [self.cells1]
                                        self.mainTable.reloadData()
                                    }
                                })
                            }
                        })
                    }
                }else{
                    self.ref.child("dish").child(cell.dish).observeSingleEvent(of: .value, with: { (snapshot) in
                        let dishSnap = snapshot.value as! [String : Any]
                        let allerArray = dishSnap["allergens"] as! [String]
                        self.ref.child("user").child(AppVariables.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                            let userSnap = snapshot.value as! [String : Any]
                            let uAllerArray = userSnap["allergens"] as! [String]
                            var match = true
                            let alerSet = Set(allerArray + uAllerArray)
                            if(alerSet.count != (allerArray.count + uAllerArray.count)) && uAllerArray[0] != "none"{
                                match = false
                            }
                            if match {
                                self.cells1.append(cell)
                                self.cells = [self.cells1]
                                self.mainTable.reloadData()
                            }
                        })
                    })
                }
            }
            
        })
    }
    @IBOutlet weak var mainTable: UITableView!{
        didSet {
            mainTable.dataSource = self
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section]
    }
    func tableView(_ tableView : UITableView, numberOfRowsInSection section : Int) -> Int {
        var count : Int = 0
        if(cells.isEmpty == false){
            count = cells[section].count
        }
        return count
    }
    func tableView(_ tableView : UITableView, cellForRowAt indexPath : IndexPath) -> UITableViewCell {
        ref = Database.database().reference()
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "dish", for: indexPath) as? MainDishTableViewCell else {
            fatalError()
        }
        cell.priceLabel.text = "£\(String(cells[indexPath.section][indexPath.row].price))0"
        cell.dateLabel.text = cells[indexPath.section][indexPath.row].date
        var starRating : Float = 0
        var revNum : Float = 0
        ref.child("dish").child(cells[indexPath.section][indexPath.row].dish).observeSingleEvent(of: .value, with: { (snapshot) in
            let dishSnap = snapshot.value as! [String : Any]
            cell.titleLabel.text = dishSnap["title"] as? String
            cell.cuisineLabel.text = dishSnap["cuisine"] as? String
            self.ref.child("review").queryOrdered(byChild : "seller").queryEqual(toValue : dishSnap["user"] as? String).observeSingleEvent(of : .value, with : { (snapshot) in
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let revSnap = snap.value as! [String : Any]
                    starRating += revSnap["rating"] as! Float
                    revNum += 1
                }
                let starGImage = UIImage(named: "stargrey.jpg")
                if(revNum > 0){
                    starRating = starRating/revNum
                    let starImage = UIImage(named: "star.jpg")
                    switch starRating {
                    case 0.7...1.7:
                        cell.star1.image = starImage
                        cell.star2.image = starGImage
                        cell.star3.image = starGImage
                        cell.star4.image = starGImage
                        cell.star5.image = starGImage
                    case 1.7...2.7:
                        cell.star1.image = starImage
                        cell.star2.image = starImage
                        cell.star3.image = starGImage
                        cell.star4.image = starGImage
                        cell.star5.image = starGImage
                    case 2.7...3.7:
                        cell.star1.image = starImage
                        cell.star2.image = starImage
                        cell.star3.image = starImage
                        cell.star4.image = starGImage
                        cell.star5.image = starGImage
                    case 3.7...4.7:
                        cell.star1.image = starImage
                        cell.star2.image = starImage
                        cell.star3.image = starImage
                        cell.star4.image = starImage
                        cell.star5.image = starGImage
                    case 4.7...5:
                        cell.star1.image = starImage
                        cell.star2.image = starImage
                        cell.star3.image = starImage
                        cell.star4.image = starImage
                        cell.star5.image = starImage
                    default:
                        break;
                    }
                }else {
                    cell.star1.image = starGImage
                    cell.star2.image = starGImage
                    cell.star3.image = starGImage
                    cell.star4.image = starGImage
                    cell.star5.image = starGImage
                }
                 cell.revLabel.text = "(\(Int(revNum)))"
            })
        })
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let reference = storageRef.child("dish-imgs/\(cells[indexPath.section][indexPath.row].dish).png")
        let place = UIImage(named: "Logo.jpg")
        cell.pic.sd_setImage(with: reference, placeholderImage: place)
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if(segue.identifier == "showInstance"){
            let navController = segue.destination as? UINavigationController
            let viewDInstanceController = navController?.topViewController as! ViewDInstanceViewController
            let selectedDishCell = sender as! MainDishTableViewCell
            let indexPath = mainTable.indexPath(for: selectedDishCell)
            mainTable.deselectRow(at: indexPath!, animated: false)
            let inst = DishInstance()
            inst.key = cells[0][indexPath!.row].key
            inst.dish = cells[0][indexPath!.row].dish
            inst.price = cells[0][indexPath!.row].price
            inst.remain = cells[0][indexPath!.row].taken
            inst.taken = cells[0][indexPath!.row].remain
            inst.seller = cells[0][indexPath!.row].seller
            inst.date = cells[0][indexPath!.row].date
            viewDInstanceController.instance = inst
        }
    }
}
