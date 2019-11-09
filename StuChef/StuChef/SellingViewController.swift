//
//  SellingViewController.swift
//  StuChef
//
//  Created by Tom Fullylove on 20/10/2018.
//  Copyright © 2018 Tom Fullylove. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseUI

class SellingViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var ref : DatabaseReference!
    var cells = [[TableCell]]()
    var cells1 = [TableCell]()
    var cells2 = [TableCell]()
    var sections = ["Orders", "Scheduled Dishes"]
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cells1 = []
        cells2 = []
        cells = []
        getContent()
    }
    func getContent(){
        ref = Database.database().reference()
        ref.child("order").queryOrdered(byChild : "seller").queryEqual(toValue : AppVariables.uid).observeSingleEvent(of : .value, with : { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let orderSnap = snap.value as! [String : Any]
                if(orderSnap["complete"] as! Bool == false){
                    let cell = TableCell()
                    cell.key = snap.key
                    cell.dishI = orderSnap["dish-instance"] as! String
                    cell.type = "order"
                    cell.taken = orderSnap["quantity"] as! Int
                    self.cells1.append(cell)
                }
            }
            self.cells.append(self.cells1)
            self.ref.child("dish-instance").queryOrdered(byChild : "user").queryEqual(toValue : AppVariables.uid).observeSingleEvent(of : .value, with : { (snapshot) in
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let schedSnap = snap.value as! [String : Any]
                    if(schedSnap["available"] as! Bool){
                        let cell = TableCell()
                        cell.key = snap.key
                        cell.dish = schedSnap["dish"] as! String
                        cell.type = "instance"
                        let date = schedSnap["time"] as! [String]
                        let remain = schedSnap["quantity"] as! [Int]
                        cell.time = date[0]
                        cell.date = date[1]
                        cell.taken = remain[0]
                        cell.remain = remain[1] - remain[0]
                        self.cells2.append(cell)
                    }
                }
                self.cells.append(self.cells2)
                self.sellingTable.reloadData()
            })
        })
    }
    @IBOutlet weak var sellingTable: UITableView!{
        didSet {
            sellingTable.dataSource = self
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
        if(cells[indexPath.section][indexPath.row].type == "order"){
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "oDish", for: indexPath) as? SellerOrderDishTableViewCell else {
                fatalError()
            }
            ref.child("dish-instance").child(cells[indexPath.section][indexPath.row].dishI).observeSingleEvent(of: .value, with: { (snapshot) in
                let instSnap = snapshot.value as! [String : Any]
                self.cells[indexPath.section][indexPath.row].dish = instSnap["dish"] as! String
                self.ref.child("dish").child(self.cells[indexPath.section][indexPath.row].dish).observeSingleEvent(of: .value, with: { (snapshot) in
                    let dishSnap = snapshot.value as! [String : Any]
                    cell.titleLabel.text = dishSnap["title"] as? String
                })
                let storage = Storage.storage()
                let storageRef = storage.reference()
                let reference = storageRef.child("dish-imgs/\(self.cells[indexPath.section][indexPath.row].dish).png")
                let place = UIImage(named: "Logo.jpg")
                cell.pic.sd_setImage(with: reference, placeholderImage: place)
            })
            var portion : String = ""
            if(cells[indexPath.section][indexPath.row].taken == 1){
                portion = "portion"
            }else{
                portion = "portions"
            }
            cell.portionLabel.text = " \(cells[indexPath.section][indexPath.row].taken) \(portion)"
            return cell
        }
        if(cells[indexPath.section][indexPath.row].type == "instance"){
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "sDish", for: indexPath) as? ScheduledDishTableViewCell else {
                fatalError()
            }
            ref.child("dish").child(cells[indexPath.section][indexPath.row].dish).observeSingleEvent(of: .value, with: { (snapshot) in
                let dishSnap = snapshot.value as! [String : Any]
                cell.titleLabel.text = dishSnap["title"] as? String
                cell.cuisineLabel.text = dishSnap["cuisine"] as? String
            })
            cell.dateLabel.text = "\(cells[indexPath.section][indexPath.row].time) \(cells[indexPath.section][indexPath.row].date)"
            cell.remainLabel.text = "Taken: \(cells[indexPath.section][indexPath.row].taken) Remaining: \(cells[indexPath.section][indexPath.row].remain)"
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let reference = storageRef.child("dish-imgs/\(cells[indexPath.section][indexPath.row].dish).png")
            let place = UIImage(named: "Logo.jpg")
            cell.pic.sd_setImage(with: reference, placeholderImage: place)
            return cell
        }
        fatalError()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if(segue.identifier == "showSOrder"){
            let navController = segue.destination as? UINavigationController
            let viewOrderController = navController?.topViewController as! ViewSOrderViewController
            let selectedDishCell = sender as! SellerOrderDishTableViewCell
            let indexPath = sellingTable.indexPath(for: selectedDishCell)
            sellingTable.deselectRow(at: indexPath!, animated: false)
            let order = Order()
            order.key = cells[0][indexPath!.row].key
            order.dishI = cells[0][indexPath!.row].dishI
            order.time = cells[0][indexPath!.row].time
            viewOrderController.order = order
        }
    }
}
