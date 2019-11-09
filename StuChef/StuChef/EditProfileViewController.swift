//
//  EditProfileViewController.swift
//  StuChef
//
//  Created by Tom Fullylove on 29/04/2019.
//  Copyright © 2019 Tom Fullylove. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class EditProfileViewController : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var ref : DatabaseReference!
    @IBOutlet weak var fnameField: UITextField!
    @IBOutlet weak var snameField: UITextField!
    @IBOutlet weak var a1Field: UITextField!
    @IBOutlet weak var a2Field: UITextField!
    @IBOutlet weak var postcodeField: UITextField!
    @IBOutlet weak var uniPicker: UIPickerView!
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
    var allerArray = [Bool]()
    var uniArray = ["Loughborough University"]
    var university = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 0...13{
            allerArray.append(false)
        }
        university = uniArray[0]
        uniPicker.delegate = self
        uniPicker.dataSource = self
        ref = Database.database().reference()
        ref.child("user").child(AppVariables.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            let userSnap = snapshot.value as! [String : Any]
            let userArray = userSnap["name"] as! [String]
            let userAdd = userSnap["address"] as! [String]
            self.fnameField.text = userArray[0]
            self.snameField.text = userArray[1]
            self.a1Field.text = userAdd[0]
            self.a2Field.text = userAdd[1]
            self.postcodeField.text = userAdd[2]
        })
    }
    @IBAction func allergens(_ sender: UIButton) {
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
    @IBAction func save(_ sender: Any) {
        let i = 0
        var allerString = [String]()
        for i in i...(self.allerArray.count - 1){
            if self.allerArray[i] {
                allerString.append(AppVariables.allergens[i])
            }
        }
        if allerString.count == 0 {
            allerString.append("none")
        }
        self.ref = Database.database().reference()
        let userData = ["name": [self.fnameField.text, self.snameField.text], "allergens": allerString, "university": self.university, "address": [self.a1Field.text, self.a2Field.text, self.postcodeField.text]] as [String : Any]
        self.ref.child("user").child(AppVariables.uid).setValue(userData)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let pickerNum = uniArray.count
        return pickerNum
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let pickerData = uniArray[row]
        return pickerData
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        university = uniArray[row]
    }
}
