//
//  extension+HomeViewController.swift
//  WaterIntake
//
//  Created by Tanmay N. Gandhi on 07/12/24.
//

import Foundation
import UIKit

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func configure() {

        registerCells()
        
        tv_myDailyGoals.dataSource = self
        tv_myDailyGoals.delegate = self
    }
    
    func registerCells() {
       
        tv_myDailyGoals.register(DailyGoalsTableViewCell.register(), forCellReuseIdentifier: DailyGoalsTableViewCell.identifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDailyGoals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: DailyGoalsTableViewCell.identifier , for: indexPath) as! DailyGoalsTableViewCell
        
        let task = arrDailyGoals[indexPath.row]
        
        cell.setupCell(viewModel: task)

        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
            let edit = UIContextualAction(style: .normal, title: "Edit") { _, _, _ in

                    // Load the new storyboard and view controller
                    let addStoryboard = UIStoryboard(name: "AddWaterIntakeStoryboard", bundle: nil)
                    guard let addViewController = addStoryboard.instantiateViewController(withIdentifier: "addDailyWater") as? AddWaterIntakeViewController else {
                        print("Error: ViewController not found.")
                        return
                    }
                
                let goalToEdit = self.arrDailyGoals[indexPath.row]
                
                // set data to goal variable havinf DailyGoal property
                addViewController.goal = goalToEdit
                
                     // Have this view controller in background
                addViewController.modalPresentationStyle = .overCurrentContext
                addViewController.view.backgroundColor = UIColor.init(white: 0.2, alpha: 0.8)
                    
                    // Present the new view controller
                    self.present(addViewController, animated: true, completion: nil)
   
            }
            edit.backgroundColor = .systemMint
        
            let delete = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in

               let goalToDelete = self.arrDailyGoals[indexPath.row]
                
                let isDeleted = DailyGoalDataManager.shared.deleteDailyGoal(goalToDelete)
                    if isDeleted {
                        
                        self.showAlert(title: "Success", message: "Goal was successfully deleted.") {
                            
                            self.loadDailyGoals(for: Date().getCurrDateString(), username: self.loginName)
                        }
                        
                    } else {
                        
                        self.displayAlert("Failed to delete the goal.")
                    }

            }
            let swipeConfiguration = UISwipeActionsConfiguration(actions: [delete, edit])
            return swipeConfiguration
        } 
}
