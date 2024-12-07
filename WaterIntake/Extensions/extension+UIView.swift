//
//  extension+UIView.swift
//  WaterIntake
//
//  Created by Samir Raut on 09/12/24.
//

import Foundation
import UIKit

extension UIView {
    
    func addTapGestureToDismissKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.addGestureRecognizer(tap)
    }
    
    func addShadow() {
        self.layer.cornerRadius = 15
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shadowRadius = 5
        self.layer.masksToBounds = false
    }
    
}

