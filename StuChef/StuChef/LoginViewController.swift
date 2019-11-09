//
//  LoginViewController.swift
//  StuChef
//
//  Created by Tom Fullylove on 25/04/2019.
//  Copyright © 2019 Tom Fullylove. All rights reserved.
//
import UIKit
import FirebaseAuth
import Firebase

class LoginViewController : UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if Auth.auth().currentUser != nil {
            let user = Auth.auth().currentUser
            if let user = user {
                    let uid = user.uid
                    AppVariables.uid = uid
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @IBAction func login(_ sender: Any) {
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { [weak self] user, error in
            let user = Auth.auth().currentUser
            if let user = user {
                if user.email == self!.email.text! {
                    let uid = user.uid
                    AppVariables.uid = uid
                    print(uid)
                    self!.performSegue(withIdentifier: "loginSegue", sender: nil)
                }
                
            }
        }
    }
    
    @IBAction func resetPass(_ sender: Any) {
        if email.text == "" {
            let alert = UIAlertController(title: "Email field empty", message: "", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            Auth.auth().sendPasswordReset(withEmail: email.text!) { error in
                let alert = UIAlertController(title: "Reset Password email sent", message: "", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
