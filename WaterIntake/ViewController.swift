//
//  ViewController.swift
//  WaterIntake
//
//  Created by Tanmay N. Gandhi on 05/12/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tf_username: UITextField!
    
    @IBOutlet weak var tf_password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.addTapGestureToDismissKeyboard()
    }

    @IBAction func btn_login(_ sender: UIButton) {
        
        guard let username = tf_username.text, !username.isEmpty else {
            self.displayAlert("Please enter Username")
            return
        }

        guard let password = tf_password.text, !password.isEmpty else {
            self.displayAlert("Please enter Password.")
            return
        }
        
        if username != "tanmay" && password != "test@123" {
            
            self.displayAlert("Please check Username & Password.")
        } else {
            
            // Save the login state
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
            
            UserDefaults.standard.set(username, forKey: "LoginName")
            
            NotificationManager.shared.setNotification(userName: username) // Start every hr Notification
            
            let storyboard: UIStoryboard = UIStoryboard(name: "HomeStoryboard", bundle: nil)
            
           if let viewcontroller: UIViewController = storyboard.instantiateViewController(identifier: "HomeDisplay") as? HomeViewController {
                
                self.present(viewcontroller, animated: false, completion: nil)
            }
            
        }
        
    }

}

