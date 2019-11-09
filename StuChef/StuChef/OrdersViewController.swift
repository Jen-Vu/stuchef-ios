//
//  OrdersViewController.swift
//  StuChef
//
//  Created by Tom Fullylove on 20/10/2018.
//  Copyright © 2018 Tom Fullylove. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseUI

class OrdersViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var ref : DatabaseReference!
    var cells = [[TableCell]]()
    var cells1 = [TableCell]()
    var cells2 = [TableCell]()
    var sections = ["Current", "Past"]
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
        ref.child("order").queryOrdered(byChild : "buyer").queryEqual(toValue : AppVariables.uid).observeSingleEvent(of : .value, with : { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let orderSnap = snap.value as! [String : Any]
                let cell = TableCell()
                cell.key = snap.key
                cell.dishI = orderSnap["dish-instance"] as! String
                cell.taken = orderSnap["quantity"] as! Int
                cell.date = orderSnap["date"] as! String
                cell.ready = orderSnap["ready"] as! Bool
                cell.seller = orderSnap["seller"] as! String
                if(orderSnap["complete"] as! Bool){
                    cell.type = "past"
                    self.cells2.append(cell)
                }else{
                   cell.type = "current"
                    if(orderSnap["ready"] as! Bool){
                        cell.time = "Ready"
                    }else{
                        cell.time = "Not Ready"
                    }
                   self.cells1.append(cell)
                }
            }
            self.cells = [self.cells1, self.cells2]
            self.ordersTable.reloadData()
        })
    }
    @IBOutlet weak var ordersTable: UITableView!{
        didSet {
            ordersTable.dataSource = self
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
        if(cells[indexPath.section][indexPath.row].type == "current"){
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ocDish", for: indexPath) as? OrderDishTableViewCell else {
                fatalError()
            }
            ref.child("dish-instance").child(cells[indexPath.section][indexPath.row].dishI).observeSingleEvent(of: .value, with: { (snapshot) in
                let instSnap = snapshot.value as! [String : Any]
                self.cells[indexPath.section][indexPath.row].dish = instSnap["dish"] as! String
                let storage = Storage.storage()
                let storageRef = storage.reference()
                let reference = storageRef.child("dish-imgs/\(self.cells[indexPath.section][indexPath.row].dish).png")
                let place = UIImage(named: "Logo.jpg")
                cell.pic.sd_setImage(with: reference, placeholderImage: place)
                self.ref.child("dish").child(self.cells[indexPath.section][indexPath.row].dish).observeSingleEvent(of: .value, with: { (snapshot) in
                    let dishSnap = snapshot.value as! [String : Any]
                    cell.titleLabel.text = dishSnap["title"] as? String
                    cell.cuisineLabel.text = dishSnap["cuisine"] as? String
                })
            })
            cell.readyLabel.text = cells[indexPath.section][indexPath.row].time
            return cell
        }
        if(cells[indexPath.section][indexPath.row].type == "past"){
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "opDish", for: indexPath) as? OrderDishTableViewCell else {
                fatalError()
            }
            ref.child("dish-instance").child(cells[indexPath.section][indexPath.row].dishI).observeSingleEvent(of: .value, with: { (snapshot) in
                let instSnap = snapshot.value as! [String : Any]
                self.cells[indexPath.section][indexPath.row].dish = instSnap["dish"] as! String
                let storage = Storage.storage()
                let storageRef = storage.reference()
                let reference = storageRef.child("dish-imgs/\(self.cells[indexPath.section][indexPath.row].dish).png")
                let place = UIImage(named: "Logo.jpg")
                cell.pic.sd_setImage(with: reference, placeholderImage: place)
                self.ref.child("dish").child(self.cells[indexPath.section][indexPath.row].dish).observeSingleEvent(of: .value, with: { (snapshot) in
                    let dishSnap = snapshot.value as! [String : Any]
                    cell.titleLabel.text = dishSnap["title"] as? String
                })
            })
            return cell
        }
        fatalError()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if(segue.identifier == "showOrder"){
            let navController = segue.destination as? UINavigationController
            let viewOrderController = navController?.topViewController as! ViewOrderViewController
            let selectedDishCell = sender as! OrderDishTableViewCell
            let indexPath = ordersTable.indexPath(for: selectedDishCell)
            ordersTable.deselectRow(at: indexPath!, animated: false)
            let order = Order()
            order.key = cells[0][indexPath!.row].key
            order.dishI = cells[0][indexPath!.row].dishI
            order.time = cells[0][indexPath!.row].time
            order.date = cells[0][indexPath!.row].date
            order.quantity = cells[0][indexPath!.row].taken
            order.ready = cells[0][indexPath!.row].ready
            order.seller = cells[0][indexPath!.row].seller
            viewOrderController.order = order
        }
    }
}
