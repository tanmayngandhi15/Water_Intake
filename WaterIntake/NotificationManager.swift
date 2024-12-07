//
//  NotificationManager.swift
//  WaterIntake
//
//  Created by Tanmay N. Gandhi on 07/12/24.
//

import Foundation
import UserNotifications

class NotificationManager {
    
    static let shared = NotificationManager()
    
    func setNotification(userName name: String?) {
        
        if let _ = UserDefaults.standard.object(forKey: "hasNotificationSetKey") {
            
            return
        }
        
        UserDefaults.standard.set(true, forKey: "hasNotificationSetKey")

        guard let name = name else {
            print("LoginName not found.")
            return
        }
        
        // Request notification permissions
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                
                // Prepare notification content
                let content = UNMutableNotificationContent()
                content.title = "Time to Hydrate! 💧"
                content.body = "\(name) It's been an hour. Take a moment to drink a glass of water and stay refreshed!"
                content.sound = .default
                content.userInfo = ["value": "Data with local notification"]
                
                // Trigger after every 1 hour (3600 seconds)
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3600, repeats: true)
                
                // Create the request
                let request = UNNotificationRequest(identifier: "reminder", content: content, trigger: trigger)
                
                // Add the notification request
                center.add(request) { error in
                    if let error = error {
                        print("Error adding notification: \(error.localizedDescription)")
                    } else {
                        print("Notification scheduled successfully!")
                    }
                }
            } else if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            } else {
                print("Notification permission denied.")
            }
        }
    }
}
