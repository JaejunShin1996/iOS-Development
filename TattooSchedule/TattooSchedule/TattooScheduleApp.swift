//
//  TattooScheduleApp.swift
//  TattooSchedule
//
//  Created by Jaejun Shin on 14/6/2022.
//

import SwiftUI

@main
struct TattooScheduleApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
