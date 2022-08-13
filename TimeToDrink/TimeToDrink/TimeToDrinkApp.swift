//
//  TimeToDrinkApp.swift
//  TimeToDrink
//
//  Created by Jaejun Shin on 13/8/2022.
//

import SwiftUI

@main
struct TimeToDrinkApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .defaultAppStorage(UserDefaults(suiteName: "group.com.jaejunshin.TimeToDrink") ?? .standard)
        }
    }
}
