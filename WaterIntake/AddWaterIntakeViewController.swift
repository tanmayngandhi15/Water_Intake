//
//  extension+ViewController.swift
//  WaterIntake
//
//  Created by Tanmay N. Gandhi on 05/12/24.
//

import UIKit

 

class AddWaterIntakeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var waterIntakeSegment: UISegmentedControl!
    @IBOutlet var vw_waterIntake: UIView!
    @IBOutlet var lbl_header: UILabel!
    @IBOutlet var lblGlass: UILabel!
    @IBOutlet var lblBottle: UILabel!
    @IBOutlet var slider: UISlider!
    @IBOutlet var sliderStart: UILabel!
    @IBOutlet var sliderEnd: UILabel!
    @IBOutlet var btnAdd: UIButton!
    @IBOutlet var txtML: UITextField!

    let loginName = UserDefaults.standard.string(forKey: "LoginName")
    
    var goal: DailyGoals?
    
    let waterIntakeViewModel = WaterIntakeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtML.delegate = self
        
        slider.minimumValue = waterIntakeViewModel.sliderMinValue
        slider.maximumValue = waterIntakeViewModel.sliderMaxValue
        slider.value = waterIntakeViewModel.sliderMinValue
        
        sliderStart.text = "\(Int(waterIntakeViewModel.sliderMinValue))ml"
        sliderEnd.text = "\(Int(waterIntakeViewModel.sliderMaxValue))ml"
        
        waterIntakeSegment.setImage(UIImage(named: "water-glass")?.withRenderingMode(.alwaysOriginal), forSegmentAt: 0)
        waterIntakeSegment.setImage(UIImage(named: "water-bottle")?.withRenderingMode(.alwaysOriginal), forSegmentAt: 1)
        
        waterIntakeSegment.selectedSegmentIndex = 0
        
        waterIntakeSegment.apportionsSegmentWidthsByContent = false
        waterIntakeSegment.setWidth(110, forSegmentAt: 0)
        waterIntakeSegment.setWidth(110, forSegmentAt: 1)

        txtML.text = "\(Int(waterIntakeViewModel.sliderMinValue))"
        
        btnAdd.layer.cornerRadius = 17
        
        addShadow(to: vw_waterIntake)
        
        updateLabel()
        
        if let goal = goal {
            
            if let waterQty = goal.waterIntake {
                slider.value = Float(waterQty) ?? waterIntakeViewModel.sliderMinValue
                sliderStart.text = "\(waterQty)ml"
                
                let selectType = (goal.containerType == "GLASS") ? 0 : 1
 
                waterIntakeSegment.selectedSegmentIndex = selectType
 
                txtML.text = "\(waterQty)"
                btnAdd.setTitle("UPDATE", for: .normal)
            }
        }
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func btnAdd(_ sender: UIButton)
    {
         
        if slider.value <= 0 {
            showAlert(title: "Invalid Input", message: "Please select a valid water intake value.") {
                ()
            }
            return
        }
        
        let selectedSegment = waterIntakeSegment.selectedSegmentIndex
        let intWaterValue = Int(slider.value)
        let waterValue = String(intWaterValue)
        let type = (selectedSegment == 0) ? "GLASS" : "BOTTLE"
        
        if let goal = goal {

            if updateDailyGoal(oldGoal: goal, containerTyp: type, waterQty: waterValue) {
                showAlert(title: "Success", message: "Record has been updated!") {
                    self.jumpToHome()
                }
            }
            
        } else {

                if createDailyGoal(containerTyp: type, waterQty: String(waterValue)) {
                    
                    showAlert(title: "Success", message: "Record has been added!") {
                        self.jumpToHome()
                    }
                }
        }
        
    }
    
    @IBAction func btnSlider(_ sender: UISlider) {
        
        updateLabel()
    }

    func createDailyGoal(containerTyp: String, waterQty: String) -> Bool {
        do {
          
            let date = Date()
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let formattedDate = outputFormatter.string(from: date) // Output: 2024-12-06 09:36:00

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
    
    func updateLabel() {
        let currentValue = Int(slider.value)
        sliderStart.text = "\(currentValue)ml"
        txtML.text = "\(currentValue)"
    }
    
    func updateSlider(_ silderText: String) {

            if let currentValue = Int(silderText) {
                sliderStart.text = "\(currentValue)ml"
                slider.value = Float(currentValue)
        }
        
    }
    
    func addShadow(to view: UIView) {
        view.layer.cornerRadius = 15
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowRadius = 5
        view.layer.masksToBounds = false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let currentText = textField.text ?? ""
        let textAsNSString = currentText as NSString

        // Determine the updated text based on the backspace or added character
        let updatedText = textAsNSString.replacingCharacters(in: range, with: string)
        
        let waterValue = (updatedText != "") ? updatedText : "0.0"

        if Float(waterValue) ?? 0.0 >= slider.minimumValue, Float(waterValue) ?? 0.0 <= slider.maximumValue {

            updateSlider(updatedText)
            
               } else {
        
                   print("Invalid or out-of-range value entered.")
                   return false
               }
        
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(#function)
    }
    
    
    @IBAction func btn_jumpHomePage(_ sender: UIButton) {
        
        jumpToHome()
    }
    
    func jumpToHome() {
        let storyboard: UIStoryboard = UIStoryboard(name: "HomeStoryboard", bundle: nil)
        
       if let viewcontroller: UIViewController = storyboard.instantiateViewController(identifier: "HomeDisplay") as? HomeViewController {
            
            self.present(viewcontroller, animated: false, completion: nil)
        }
    }

}
