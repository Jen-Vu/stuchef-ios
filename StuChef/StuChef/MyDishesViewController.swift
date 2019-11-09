//
//  MyDishesViewController.swift
//  StuChef
//
//  Created by Tom Fullylove on 01/04/2019.
//  Copyright © 2019 Tom Fullylove. All rights reserved.
//
import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseUI

class MyDishesViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
     
    var database : DatabaseReference!
    var dishes = [Dish]()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dishes = []
        getContent()
    }
    func getContent(){
        Database.database().reference().child("dish").queryOrdered(byChild : "user").queryEqual(toValue : AppVariables.uid).observeSingleEvent(of : .value, with : { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let dishSnap = snap.value as! [String : Any]
                let dish = Dish()
                dish.key = snap.key
                dish.title = dishSnap["title"] as! String
                dish.cuisine = dishSnap["cuisine"] as! String
                self.dishes.append(dish)
            }
            self.myDishesTable.reloadData()
        })
    }
    @IBOutlet weak var myDishesTable: UITableView!{
        didSet {
            myDishesTable.dataSource = self
        }
    }
    func numberOfSectionsInTableView(tableView : UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView : UITableView, numberOfRowsInSection section : Int) -> Int {
        var count : Int! = 0
        count = dishes.count
        return count!
    }
    func tableView(_ tableView : UITableView, cellForRowAt indexPath : IndexPath) -> UITableViewCell {
        let cellIdentifier = "myDish"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MyDishTableViewCell  else {
            fatalError()
        }
        let dish = dishes[indexPath.row]
        cell.titleLabel.text = dish.title
        cell.cuisineLabel.text = dish.cuisine
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let reference = storageRef.child("dish-imgs/\(dish.key).png")
        let place = UIImage(named: "Logo.jpg")
        cell.pic.sd_setImage(with: reference, placeholderImage: place)
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if(segue.identifier == "showMeal"){
            let navController = segue.destination as? UINavigationController
            let viewDishViewController = navController?.topViewController as! ViewDishViewController
            guard let selectedDishCell = sender as? MyDishTableViewCell else {
               fatalError()
            }
            guard let indexPath = myDishesTable.indexPath(for: selectedDishCell) else {
                fatalError()
            }
            myDishesTable.deselectRow(at: indexPath, animated: false)
            viewDishViewController.dish = dishes[indexPath.row]
        }
    }
}
