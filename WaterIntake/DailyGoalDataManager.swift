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
    
    func fetchDailyGoals(_ selectedDate: String, _ loginUserName: String) -> [DailyGoals]? {
        
        do {
            
            guard let result = try PersistentStorage.shared.context.fetch(DailyGoals.fetchRequest()) as? [DailyGoals] else {
                print("No Data")
            }
            
            let output = result.filter { goals in
                guard let byDate = goals.date, let loginName = goals.username else {
                    return false
                }
                
                return byDate.contains(selectedDate) && loginName == loginUserName
            }
            
            return output
            
        } catch let err {
          
            debugPrint(err)
            return nil
        }
        
    }
    
    func createDailyGoal(containerTyp: String, waterQty: String, loginName: String) -> Bool {
        do {

            let formattedDate =  Date().getCurrDateTimeString() // Output: 2024-12-06 09:36:00

            let goal = DailyGoals(context: PersistentStorage.shared.context)
            goal.username = loginName
            goal.date = formattedDate
            goal.containerType = containerTyp
            goal.waterIntake = waterQty

        
            try PersistentStorage.shared.saveContext()

            return true
            
        } catch let err {
         
            debugPrint("Error creating goal: \(err)")
            
            return false
        }
    }

    
    func updateDailyGoal( oldGoal: DailyGoals, containerTyp: String, waterQty: String) -> Bool {
        do {
            
            // Update the properties of the goal
            oldGoal.containerType = containerTyp
            oldGoal.waterIntake = waterQty

            // Save the context after updating
            try PersistentStorage.shared.context.save()
            
            print("Goal updated successfully")
            return true
        } catch let err {
            // Log the error and return false in case of failure
            debugPrint("Error updating goal: \(err)")
            return false
        }
    }
    
    func deleteDailyGoal(_ goal: DailyGoals) -> Bool {
        do {
            // Delete the goal from the context
            PersistentStorage.shared.context.delete(goal)
            
            // Save the context after deletion
            try PersistentStorage.shared.context.save()
            
            print("Goal deleted successfully")
            return true
        } catch let err {
            
            // Log the error and return false in case of failure
            debugPrint("Error deleting goal: \(err)")
            return false
        }
    }
    
}
