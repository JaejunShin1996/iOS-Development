//
//  AddingHabit.swift
//  HabitTracking
//
//  Created by Jaejun Shin on 28/5/2022.
//

import SwiftUI

struct AddingHabit: View {
    
    @ObservedObject var habits: Habits
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var completionCount: Int = 0
    
    var body: some View {
        NavigationView {
            VStack {
                Section(header: Text("What's your habit?")) {
                    TextField("Habit", text: $name)
                }
                Section(header: Text("Enter the description")) {
                    TextField("How would you do?", text: $description)
                }
                Section(header: Text("Change Completion Times")) {
                    Stepper(value: $completionCount, in: 0...Int.max) {
                        Text("\(completionCount) times")
                    }
                }
                
                Spacer()
            }
            .padding([.horizontal, .bottom])
            .preferredColorScheme(.dark)
            .toolbar {
                Button("Save") {
                    let newHabit = HabitItem(name: self.name, description: self.description, completionCount: self.completionCount)
                    self.habits.items.append(newHabit)
                    self.habits.saveHabits()
                    dismiss()
                }
            }
            .navigationTitle("Add a New Habit")
            
        }
    }
}

struct AddingHabit_Previews: PreviewProvider {
    static var previews: some View {
        AddingHabit(habits: Habits())
    }
}
