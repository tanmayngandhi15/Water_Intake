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

        setupUI()
        
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
        
        view.addTapGestureToDismissKeyboard()
    }
    
    @IBAction func btnAdd(_ sender: UIButton)
    {
         
        if slider.value <= 0 {
            
            displayAlert("Please select a valid water intake value.")
            return
        }
        
        let selectedSegment = waterIntakeSegment.selectedSegmentIndex
        let intWaterValue = Int(slider.value)
        let waterValue = String(intWaterValue)
        let type = (selectedSegment == 0) ? "GLASS" : "BOTTLE"
        
        if let goal = goal {

            if DailyGoalDataManager.shared.updateDailyGoal(oldGoal: goal, containerTyp: type, waterQty: waterValue) {
                
                showAlert(title: "Success", message: "Record has been updated!") {
                    self.jumpToHome()
                }
            }
            
        } else {
            
            guard let name = loginName else {
                displayAlert("Please login again.")
                return
            }

            if DailyGoalDataManager.shared.createDailyGoal(containerTyp: type, waterQty: String(waterValue), loginName: name) {
                    
                    showAlert(title: "Success", message: "Record has been added!") {
                        self.jumpToHome()
                    }
                }
        }
        
    }
    
    @IBAction func btnSlider(_ sender: UISlider) {
        
        updateLabel()
    }

    func setupUI() {
        
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
        
        vw_waterIntake.addShadow()
        
        updateLabel()
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

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let currentText = textField.text ?? ""
        let textAsNSString = currentText as NSString

        // Determine the updated text based on the backspace or added character
        let updatedText = textAsNSString.replacingCharacters(in: range, with: string)
        
        if updatedText.isEmpty {
                updateSlider("0") // Assuming "0" as the default for empty input
                txtML.text = "0"
                return false
            }

        let waterValue = Float(updatedText) ?? 0.0
        
        // Check if the value is within the valid range
            let minValue = WaterIntakeViewModel().sliderMinValue
            let maxValue = WaterIntakeViewModel().sliderMaxValue

        if waterValue >= minValue, waterValue <= maxValue {

            updateSlider(updatedText)
            
               } else {
        
                   print("Invalid or out-of-range value entered.")
                   return false
               }
        
        
        return true
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
