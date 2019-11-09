//
//  ViewDishViewController.swift
//  StuChef
//
//  Created by Tom Fullylove on 06/04/2019.
//  Copyright © 2019 Tom Fullylove. All rights reserved.
//
import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseUI

class ViewDishViewController : UIViewController, UIActionSheetDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var ref : DatabaseReference!
    var dish: Dish?
    var pricePickerData = [1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0]
    var portPickerData = [1,2,3,4,5,6,7,8]
    var datePickerData = [[String]]()
    var datePickerView : UIPickerView!
    var portPickerView : UIPickerView!
    var pricePickerView : UIPickerView!
    var dishPrice = Float()
    var dishPort = Int()
    var dishDate = [String]()
    @IBOutlet weak var cuisineLabel: UILabel!
    @IBOutlet weak var pic: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = dish!.title
        cuisineLabel.text = dish?.cuisine
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let reference = storageRef.child("dish-imgs/\(dish!.key).png")
        let place = UIImage(named: "Logo.jpg")
        pic.sd_setImage(with: reference, placeholderImage: place)
    }
    @IBAction func back(_ sender: UIBarButtonItem) {
        dismiss(animated : true, completion : nil)
    }
    @IBAction func schedule(_ sender: Any) {
        let timeData = ["8:00", "8:30", "9:00", "9:30", "10:00", "10:30", "11:00", "11:30", "12:00", "12:30", "13:00", "13:30", "14:00", "14:30", "15:00", "15:30", "16:00", "16:30", "17:00", "17:30", "18:00", "18:30", "19:00", "19:30", "20:00", "20:30", "21:00", "21:30", "22:00"]
        var dateData = [String]()
        datePickerData.append(timeData)
        let calendar = NSCalendar.current
        let startDate = Date()
        var date = calendar.date(byAdding: .day, value: 1, to: startDate)!
        let endDate = calendar.date(byAdding: .day, value: 6, to: date)!
        let fmt = DateFormatter()
        fmt.dateFormat = "dd/MM/yyyy"
        dishDate.append("8:00")
        dishDate.append(fmt.string(from: date))
        while date <= endDate {
            dateData.append(fmt.string(from: date))
            date = calendar.date(byAdding: .day, value: 1, to: date)!
        }
        datePickerData.append(dateData)
        let vc = UIViewController()
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        vc.preferredContentSize = CGSize(width: screenWidth,height: 300)
        datePickerView = UIPickerView(frame: CGRect(x: -12, y: 0, width: screenWidth, height: 100))
        portPickerView = UIPickerView(frame: CGRect(x: -12, y: 100, width: screenWidth, height: 100))
        pricePickerView = UIPickerView(frame: CGRect(x: -12, y: 200, width: screenWidth, height: 100))
        datePickerView.delegate = self
        datePickerView.dataSource = self
        portPickerView.delegate = self
        portPickerView.dataSource = self
        pricePickerView.delegate = self
        pricePickerView.dataSource = self
        vc.view.addSubview(datePickerView)
        vc.view.addSubview(portPickerView)
        vc.view.addSubview(pricePickerView)
        let editRadiusAlert = UIAlertController(title: "Schedule meal", message: "", preferredStyle: .actionSheet)
        editRadiusAlert.setValue(vc, forKey: "contentViewController")
        editRadiusAlert.addAction(UIAlertAction(title: "Schedule Meal", style: .default, handler: {(action:UIAlertAction!) in
            self.ref = Database.database().reference()
            let schedData = ["available": true, "dish": self.dish!.key, "price": self.dishPrice, "quantity": [0, self.dishPort], "time": [self.dishDate[0], self.dishDate[1]], "user": AppVariables.uid] as [String : Any]
            let id = NSUUID().uuidString
            self.ref.child("dish-instance").child(id).setValue(schedData)
        }))
        editRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(editRadiusAlert, animated: true)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        var pickerRows = 1
        if pickerView == datePickerView{
            pickerRows = 2
        }
        return pickerRows
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var pickerNum = 0
        if pickerView == datePickerView{
                pickerNum = datePickerData[component].count
        }
        if pickerView == portPickerView{
            pickerNum = portPickerData.count
        }
        if pickerView == pricePickerView{
            pickerNum = pricePickerData.count
        }
        return pickerNum
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var pickerData = ""
        if pickerView == datePickerView{
            pickerData = datePickerData[component][row]
        }
        if pickerView == portPickerView{
            var portion = "portions"
            if row == 0 {
                portion = "portion"
            }
            pickerData = "\(String(portPickerData[row])) \(portion)"
        }
        if pickerView == pricePickerView{
            pickerData = "£\(String(pricePickerData[row]))0"
        }
        return pickerData
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == datePickerView{
            dishDate[component] = "\(datePickerData[component][row])"
        }
        if pickerView == portPickerView{
            dishPort = portPickerData[row]
        }
        if pickerView == pricePickerView{
            dishPrice = Float(pricePickerData[row])
        }
    }
}
