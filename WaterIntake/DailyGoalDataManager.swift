//
//  DailyGoalDataManager.swift
//  WaterIntake
//
//  Created by Tanmay N. Gandhi on 07/12/24.
//

import Foundation

import CoreData

class DailyGoalDataManager {
    
    static let shared = DailyGoalDataManager()
    
    
    
    func calculateTotalWaterIntake(from records: [DailyGoals]) -> Double {
        
            return records.reduce(0.0) { total, record in
                
                total + (Double(record.waterIntake ?? "0.0") ?? 0.0)
            }
        }
    
    func fetchDailyGoals(_ selectedDate: String) -> [DailyGoals]? {
        
        do {
            
            guard let result = try PersistentStorage.shared.context.fetch(DailyGoals.fetchRequest()) as? [DailyGoals] else {
                print("No Data")
            }
            
            let output = result.filter { goals in
                guard let byDate = goals.date else {
                    return false
                }
                
                return byDate.contains(selectedDate)
            }
            
            return output
            
        } catch let err {
          
            debugPrint(err)
            return nil
        }
        
    }
    
}
