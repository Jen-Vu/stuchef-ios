//
//  SettingsViewController.swift
//  StuChef
//
//  Created by Tom Fullylove on 20/10/2018.
//  Copyright © 2018 Tom Fullylove. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingsViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func logout(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        self.performSegue(withIdentifier: "logoutSegue", sender: nil)
    }
}
