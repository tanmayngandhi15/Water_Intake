//
//  extension+Date.swift
//  WaterIntake
//
//  Created by Samir Raut on 09/12/24.
//

import Foundation

extension Date {
    func getCurrDateString() -> String {
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd"
        return outputFormatter.string(from: self)
    }
    
    func getCurrDateTimeString() -> String {
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return outputFormatter.string(from: self) // // Output: 2024-12-06 09:36:00
    }
}
