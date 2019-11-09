//
//  RefineViewController.swift
//  StuChef
//
//  Created by Tom Fullylove on 15/11/2018.
//  Copyright © 2018 Tom Fullylove. All rights reserved.
//
import UIKit

class RefineViewController : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var cuisinePicker: UIPickerView!
    @IBOutlet weak var dietPicker: UIPickerView!
    @IBOutlet weak var pricePicker: UIPickerView!
    @IBOutlet weak var datePicker: UIPickerView!
    @IBOutlet weak var star1: UIButton!
    @IBOutlet weak var star2: UIButton!
    @IBOutlet weak var star3: UIButton!
    @IBOutlet weak var star4: UIButton!
    @IBOutlet weak var star5: UIButton!
    @IBOutlet weak var ceAller: UIButton!
    @IBOutlet weak var crAller: UIButton!
    @IBOutlet weak var daAller: UIButton!
    @IBOutlet weak var egAller: UIButton!
    @IBOutlet weak var fiAller: UIButton!
    @IBOutlet weak var glAller: UIButton!
    @IBOutlet weak var luAller: UIButton!
    @IBOutlet weak var moAller: UIButton!
    @IBOutlet weak var muAller: UIButton!
    @IBOutlet weak var nuAller: UIButton!
    @IBOutlet weak var peAller: UIButton!
    @IBOutlet weak var seAller: UIButton!
    @IBOutlet weak var soAller: UIButton!
    @IBOutlet weak var suAller: UIButton!
    var cuisData = ["Any"]
    var dietData = ["Any"]
    var priceData : [Float] = [1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0]
    var allerArray = [Bool]()
    var price : [Float] = [1.0, 5.0]
    var date = String()
    var cuisine = String()
    var diet = String()
    var dateData = ["Any"]
    var starRating = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        cuisData += AppVariables.cuisines
        dietData += AppVariables.diets
        for _ in 0...13{
            allerArray.append(false)
        }
        let calendar = NSCalendar.current
        let startDate = Date()
        var dateD = calendar.date(byAdding: .day, value: 0, to: startDate)!
        let endDate = calendar.date(byAdding: .day, value: 6, to: dateD)!
        let fmt = DateFormatter()
        fmt.dateFormat = "dd/MM/yyyy"
        while dateD <= endDate {
            dateData.append(fmt.string(from: dateD))
            dateD = calendar.date(byAdding: .day, value: 1, to: dateD)!
        }
        date = dateData[0]
        cuisine = cuisData[0]
        diet = dietData[0]
        cuisinePicker.dataSource = self
        cuisinePicker.delegate = self
        dietPicker.dataSource = self
        dietPicker.delegate = self
        pricePicker.dataSource = self
        pricePicker.delegate = self
        datePicker.delegate = self
        datePicker.dataSource = self
        pricePicker.selectRow(priceData.count - 1, inComponent: 2, animated: true)
    }
    @IBAction func apply(_ sender: UIBarButtonItem) {
        let refine = Refine()
        refine.refine = true
        refine.cuisine = cuisine
        refine.diet = diet
        refine.price = price
        refine.rating = Float(starRating)
        refine.date = date
        let i = 0
        var allerString = [String]()
        for i in i...(allerArray.count - 1){
            if allerArray[i] {
                allerString.append(AppVariables.allergens[i])
            }
        }
        refine.allergens = allerString
        AppVariables.refine = refine
        _ = navigationController?.popViewController(animated: true)
    }
    @IBAction func star(_ sender: UIButton) {
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
    @IBAction func aller(_ sender: UIButton) {
        if sender.currentImage!.isEqual(UIImage(named : "cb-us.png")) {
            sender.setImage(UIImage(named : "cb-s.png"), for : [])
            switch sender {
            case ceAller:
                allerArray[0] = true
            case crAller:
                allerArray[1] = true
            case daAller:
                allerArray[2] = true
            case egAller:
                allerArray[3] = true
            case fiAller:
                allerArray[4] = true
            case glAller:
                allerArray[5] = true
            case luAller:
                allerArray[6] = true
            case moAller:
                allerArray[7] = true
            case muAller:
                allerArray[8] = true
            case nuAller:
                allerArray[9] = true
            case peAller:
                allerArray[10] = true
            case seAller:
                allerArray[11] = true
            case soAller:
                allerArray[12] = true
            case suAller:
                allerArray[13] = true
            default:
                break;
            }
        }else {
            sender.setImage(UIImage(named : "cb-us.png"), for : [])
            switch sender {
            case ceAller:
                allerArray[0] = false
            case crAller:
                allerArray[1] = false
            case daAller:
                allerArray[2] = false
            case egAller:
                allerArray[3] = false
            case fiAller:
                allerArray[4] = false
            case glAller:
                allerArray[5] = false
            case luAller:
                allerArray[6] = false
            case moAller:
                allerArray[7] = false
            case muAller:
                allerArray[8] = false
            case nuAller:
                allerArray[9] = false
            case peAller:
                allerArray[10] = false
            case seAller:
                allerArray[11] = false
            case soAller:
                allerArray[12] = false
            case suAller:
                allerArray[13] = false
            default:
                break;
            }
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        var count = 1
        if pickerView == pricePicker{
            count = 3
        }
        return count
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var count = 1
        if pickerView == pricePicker{
            if component == 1{
                count = 1
            }else{
                count = priceData.count
            }
        } else if pickerView == dietPicker{
            count = dietData.count
        } else if pickerView == cuisinePicker{
            count = cuisData.count
        } else if pickerView == datePicker{
            count = dateData.count
        }
        return count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var data = ""
        if pickerView == pricePicker{
            if component == 1{
                data = "to"
            }else{
                data = "£\(priceData[row])0"
            }
        } else if pickerView == dietPicker{
            data = dietData[row]
        } else if pickerView == cuisinePicker{
            data = cuisData[row]
        } else if pickerView == datePicker{
            data = dateData[row]
        }
        return data
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pricePicker{
            if component == 0{
                price[0] = priceData[row]
            }else if component == 2{
                price[1] = priceData[row]
            }
        } else if pickerView == dietPicker{
            diet = dietData[row]
        } else if pickerView == cuisinePicker{
            cuisine = cuisData[row]
        } else if pickerView == datePicker{
            date = dateData[row]
        }
    }
}
