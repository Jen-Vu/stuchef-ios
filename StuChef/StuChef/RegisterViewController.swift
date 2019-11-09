//
//  RegisterViewController.swift
//  StuChef
//
//  Created by Tom Fullylove on 25/04/2019.
//  Copyright © 2019 Tom Fullylove. All rights reserved.
//
import UIKit
import FirebaseAuth
import FirebaseDatabase
import Firebase

class RegisterViewController : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var ref : DatabaseReference!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var cPassField: UITextField!
    @IBOutlet weak var fNameField: UITextField!
    @IBOutlet weak var sNameField: UITextField!
    @IBOutlet weak var addressL1Field: UITextField!
    @IBOutlet weak var addressL2Field: UITextField!
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
    var errorString = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        for _ in 0...13{
            allerArray.append(false)
        }
        university = uniArray[0]
        uniPicker.delegate = self
        uniPicker.dataSource = self
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
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
    @IBAction func signup(_ sender: Any) {
        var error = false
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if emailField.text == "" || passField.text == "" || fNameField.text == "" || sNameField.text == "" || addressL1Field.text == "" || addressL2Field.text == "" || postcodeField.text == ""{
            error = true
            errorString = AppVariables.error[0]
        } else if emailTest.evaluate(with: emailField.text) == false || !(emailField.text?.contains(".ac.uk"))!{
            error = true
            print("yes")
            errorString = AppVariables.error[1]
        } else if passField.text != cPassField.text {
            error = true
            errorString = AppVariables.error[2 ]
        }
        if error {
            let alert = UIAlertController(title: "Sign up unsuccessful", message: errorString, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            Auth.auth().createUser(withEmail: emailField.text!, password: passField.text!) { authResult, error in
                let user = Auth.auth().currentUser
                if let _eror = error {
                    //something bad happning
                    print(_eror.localizedDescription )
                }else{
                    if let user = user {
                        let uid = user.uid
                        AppVariables.uid = uid
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
                        let userData = ["name": [self.fNameField.text, self.sNameField.text], "allergens": allerString, "university": self.university, "address": [self.addressL1Field.text, self.addressL2Field.text, self.postcodeField.text]] as [String : Any]
                        self.ref.child("user").child(uid).setValue(userData)
                        self.performSegue(withIdentifier: "showlogin", sender: nil)
                    }
                }
            }
        }
    }
    @IBAction func back(_ sender: UIBarButtonItem) {
        dismiss(animated : true, completion : nil)
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
