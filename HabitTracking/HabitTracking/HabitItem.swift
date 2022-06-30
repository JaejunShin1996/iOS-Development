//
//  Habits.swift
//  HabitTracking
//
//  Created by Jaejun Shin on 28/5/2022.
//

import Foundation

struct HabitItem: Codable, Identifiable, Equatable {
    var id = UUID()
    var name: String
    var description: String
    var completionCount: Int
}
