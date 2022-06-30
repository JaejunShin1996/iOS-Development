//
//  HabitDetailView.swift
//  HabitTracking
//
//  Created by Jaejun Shin on 29/5/2022.
//

import SwiftUI

struct HabitDetailView: View {
    @ObservedObject var habits: Habits
    @State private var completedTimes = 0
    
    var habit: HabitItem
    
    var body: some View {
        Form {
            VStack {
                Section {
                    Text(habit.description)
                        .font(.body)
                }
                
                Section {
                    Stepper(value: $completedTimes, in: 0...Int.max) {
                        Text("Completed Times: \(self.completedTimes)")
                    }
                }
                
                Spacer()
                
            }
        }
        .preferredColorScheme(.dark)
        .navigationTitle(self.habit.name)
        .toolbar {
            Button {
                self.saveHabit()
            } label: {
                Text("Save")
            }
        }
        .onAppear {
            self.completedTimes = self.habit.completionCount
        }

    }
    
    func saveHabit() {
        if let indexItem = self.habits.items.firstIndex(where: { (item) -> Bool in
            item == self.habit
        }) {
            let tempHabit = HabitItem(name: self.habit.name, description: self.habit.description, completionCount: self.completedTimes)
            self.habits.items.remove(at: indexItem)
            self.habits.items.insert(tempHabit, at: indexItem)
            
            
            self.habits.saveHabits()
        }
    }
}

struct HabitDetailView_Previews: PreviewProvider {
    static var previews: some View {
        HabitDetailView(habits: Habits(), habit: HabitItem(name: "name", description: "description", completionCount: 0))
    }
}
