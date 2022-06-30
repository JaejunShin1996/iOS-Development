//
//  Habits.swift
//  HabitTracking
//
//  Created by Jaejun Shin on 28/5/2022.
//

import Foundation

class Habits: ObservableObject {
    @Published var items = [HabitItem]()
    
    func saveHabits() {
        let encoder = JSONEncoder()
        
        if let encoded = try? encoder.encode(items) {
            UserDefaults.standard.set(encoded, forKey: "Items")
        }
    }
    
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decoded = try? JSONDecoder().decode([HabitItem].self, from: savedItems) {
                self.items = decoded
                return
            }
        }
        self.items = []
    }
}
