//
//  ContentView.swift
//  HabitTracking
//
//  Created by Jaejun Shin on 28/5/2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var habits = Habits()
    
    @State private var showingAddingHabit = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(habits.items) { habit in
                    NavigationLink(destination: HabitDetailView(habits: self.habits, habit: habit)) {
                        HStack {
                            VStack {
                                Text(habit.name)
                                    .font(.largeTitle)
                                    .bold()
                                
                                Text(habit.description)
                                    .font(.body)
                            }
                            
                            Spacer()
                            
                            Text("\(habit.completionCount)")
                                .font(.largeTitle)
                                .bold()
                        }
                    }
                }
                .onDelete(perform: removeItem)
            }
            .navigationTitle("Habit Tracker")
            .preferredColorScheme(.dark)
            .toolbar {
                Button {
                    showingAddingHabit.toggle()
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                }
            }
            .sheet(isPresented: $showingAddingHabit) {
                AddingHabit(habits: self.habits)
            }
        }
    }
    
    func removeItem(at offsets: IndexSet) {
        self.habits.items.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
