//
//  Content-ViewModel.swift
//  MPOO_FinalProject
//
//  Created by Alan Carrasco on 17/01/23.
//

import Foundation
import UserNotifications

extension PomodoroTimerView{
    final class ViewModel: ObservableObject{
        @Published var isActive = false
        @Published var showingAlert = false
        @Published var time: String = "10:00"
        @Published var minutes: Float = 10.0{
            didSet{
                self.time = "\(Int(minutes)):00"
            }
        }
        
        private var initialTime = 10
        private var endDate = Date()
        
        func start(minutes: Float) {
            self.initialTime = Int(minutes)
            self.endDate = Date()
            self.isActive = true
            self.endDate = Calendar.current.date(byAdding: .minute, value: Int(minutes), to: endDate)!
        }
        
        func reset() {
            self.minutes = Float(initialTime)
            self.isActive = false
            self.time = "\(Int(minutes)):00"
        }
        
        func updateCountdown (){
            let now = Date()
            let diferencia = endDate.timeIntervalSince1970 - now.timeIntervalSince1970
            
            if diferencia <= 0 {
                self.isActive = false
                self.time = "0:00"
                self.showingAlert = true
                self.Notify()
                return
            }
            
            let date = Date(timeIntervalSince1970: diferencia)
            let calendar = Calendar.current
            let minutes = calendar.component(.minute, from: date)
            let seconds = calendar.component(.second, from: date)
            
            self.minutes = Float(minutes)
            self.time = String(format: "%d:%02d", minutes, seconds)
        }
        
        func Notify(){
            let content = UNMutableNotificationContent()
            content.title = "Real Focus"
            content.body = "¡Sesión completada!"
            content.sound = UNNotificationSound.default
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let solicitud = UNNotificationRequest(identifier: "MSG", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(solicitud, withCompletionHandler: nil)
        }
    }
}

