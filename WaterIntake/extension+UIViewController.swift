//
//  extension+ViewController.swift
//  WaterIntake
//
//  Created by Tanmay N. Gandhi on 05/12/24.
//

import Foundation
import UIKit

extension UIViewController {
    
    func displayAlert(_ desc: String) {
        
        let alertController = UIAlertController(title: "Alert", message: desc, preferredStyle: .alert)
        // Create the actions
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
        // Add the actions
        alertController.addAction(okAction)
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func showAlert(title: String, message: String, onOk: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            
            onOk!()
        }))
        present(alert, animated: true, completion: nil)
    }
    
}
