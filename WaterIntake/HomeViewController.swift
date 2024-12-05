//
//  HomeViewController.swift
//  WaterIntake
//
//  Created by Tanmay N. Gandhi on 05/12/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    // Do any additional setup after loading the view.
    
    @IBOutlet weak var lbl_dailyWaterPercentage: UILabel!
    
    @IBOutlet weak var pg_dailyWaterMeter: UIProgressView!
    
    @IBOutlet weak var tv_myDailyGoals: UITableView!
    
    @IBOutlet weak var btn_addGoals: UIButton!
    
    @IBOutlet weak var btn_logOut: UIButton!
    
    var arrDailyGoals: [DailyGoals] = []
    
    let dailyMaxIntake = Double(WaterIntakeViewModel().sliderMaxValue) // ml
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        NotificationManager.shared.setNotification() // Start every hr Notification
        
        configure() // Configure the TableView

        loadDailyGoals(for: getCurrDateString()) // Fetch Dailys Records as per current Date
    }
    
    func getCurrDateString() -> String {
        let date = Date()
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd"
        return outputFormatter.string(from: date)
    }
    
    func setupUI() {
        
        btn_addGoals.layer.cornerRadius = btn_addGoals.frame.height / 2
        btn_logOut.layer.cornerRadius = btn_logOut.frame.height / 5
    }
    
    @IBAction func btn_clickLogout(_ sender: UIButton) {
        
        let alertController = UIAlertController(
                title: "Exit App",
                message: "Are you sure you want to close the application?",
                preferredStyle: .alert
            )
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: "Exit", style: .destructive, handler: { _ in
                exit(0) // Close the app
            }))
            
            present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func btn_clickAddGoals(_ sender: UIButton) {
        
        // Load the new storyboard and view controller
        let addStoryboard = UIStoryboard(name: "AddWaterIntakeStoryboard", bundle: nil)
        guard let addViewController = addStoryboard.instantiateViewController(withIdentifier: "addDailyWater") as? AddWaterIntakeViewController else {
            print("Error: ViewController not found.")
            return
        }
  
         // Have this view controller in background
    addViewController.modalPresentationStyle = .overCurrentContext
    addViewController.view.backgroundColor = UIColor.init(white: 0.2, alpha: 0.8)
        
        // Present the new view controller
        self.present(addViewController, animated: true, completion: nil)
    }
    
    func loadDailyGoals(for date: String) {
        if let records = DailyGoalDataManager.shared.fetchDailyGoals(date) {
                arrDailyGoals = records
                let totalWaterIntake = DailyGoalDataManager.shared.calculateTotalWaterIntake(from: records)
                setWaterMeter(totalWaterIntake)
                tv_myDailyGoals.reloadData()
            }
        }
    
    func setWaterMeter(_ myTotal: Double) {
        let myDailyMeter = Float(myTotal / dailyMaxIntake)
        var myDailyPercentage = Int(myDailyMeter * 100)
        if myDailyPercentage > 100 {
            myDailyPercentage = 100
        }

        lbl_dailyWaterPercentage.text = "\(myDailyPercentage) %"
        pg_dailyWaterMeter.setProgress(myDailyMeter, animated: true)
    }
    
}
