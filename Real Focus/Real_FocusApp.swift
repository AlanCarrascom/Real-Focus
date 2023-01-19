//
//  MPOO_FinalProjectApp.swift
//  MPOO_FinalProject
//
//  Created by Alan Carrasco on 08/01/23.
//

import SwiftUI

@main
struct Real_FocusApp: App {
    
    @StateObject private var dataController = DataController()
    
    init(){
        UINavigationBar
            .appearance()
            .largeTitleTextAttributes = [.foregroundColor : UIColor.red]
    }
    
    var body: some Scene {
        WindowGroup {
            PomodoroTimerView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
