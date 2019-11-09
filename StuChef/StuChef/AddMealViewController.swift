//
//  AddMealViewController.swift
//  StuChef
//
//  Created by Tom Fullylove on 29/01/2019.
//  Copyright © 2019 Tom Fullylove. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class AddMealViewController : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var imageStr : String = ""
    var ref : DatabaseReference!
    var cuisData = [String]()
    var dietData = [String]()
    var allergens = ["", ""]
    var allerArray = [Bool]()
    var cuisine = String()
    var diet = String()
    var pic = UIImage()
    @IBOutlet weak var dishImage: UIImageView!
    @IBOutlet weak var dishTitle: UITextField!
    @IBOutlet weak var dishDesc: UITextView!
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
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddMealViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        for _ in 0...13{
            allerArray.append(false)
        }
        dietData.append("None")
        cuisData += AppVariables.cuisines
        dietData += AppVariables.diets
        pickerCuis.dataSource = self
        pickerCuis.delegate = self
        pickerDiet.dataSource = self
        pickerDiet.delegate = self
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @IBOutlet weak var pickerCuis: UIPickerView!
    @IBOutlet weak var pickerDiet: UIPickerView!
    
    @IBAction func imgSelect(_ sender : UIButton) {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = (self as UIImagePickerControllerDelegate & UINavigationControllerDelegate);
        myPickerController.sourceType =  UIImagePickerController.SourceType.photoLibrary
        self.present(myPickerController, animated : true, completion : nil)
    }
    @IBAction func checkbox(_ sender : UIButton) {
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
    @IBAction func Back(_ sender: UIBarButtonItem) {
        dismiss(animated : true, completion : nil)
    }
    @IBAction func save(_ sender : UIBarButtonItem) {
        var error = false
        var errorString = ""
        if dishTitle.text == "" || dishDesc.text == ""{
            error = true
            errorString = AppVariables.error[0]
        }
        if error {
            let alert = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
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
            let id = NSUUID().uuidString
            let imageName:String = String("\(id).png")
            let storageRef = Storage.storage().reference().child("dish-imgs").child(imageName)
            if let uploadData = pic.pngData(){
                storageRef.putData(uploadData, metadata: nil
                    , completion: { (metadata, error) in
                        if error != nil {
                            print("error")
                            return
                        }
                })
            }
            self.ref = Database.database().reference()
            let dishData = ["user": AppVariables.uid, "cuisine": cuisine, "diet": diet, "title": dishTitle.text!, "description": dishDesc.text!, "allergens": allerString] as [String : Any]
            self.ref.child("dish").child(id).setValue(dishData)
             dismiss(animated : true, completion : nil)
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var count = 0
        if pickerView == pickerCuis {
            count = cuisData.count
        } else if pickerView == pickerDiet {
            count = dietData.count
        }
        return count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var data = String()
        if pickerView == pickerCuis {
            data = cuisData[row]
        } else if pickerView == pickerDiet {
            data = dietData[row]
        }
        return data
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerCuis {
            cuisine = cuisData[row]
        } else if pickerView == pickerDiet {
            diet = dietData[row]
        }
    }
}
extension AddMealViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info : [UIImagePickerController.InfoKey : Any])
    {
        let image_data = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        pic = image_data!
        dishImage.image = pic
        self.dismiss(animated : true, completion : nil)
    }
}
