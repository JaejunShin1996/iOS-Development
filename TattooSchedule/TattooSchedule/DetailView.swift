//
//  DetailView.swift
//  TattooSchedule
//
//  Created by Jaejun Shin on 14/6/2022.
//

import SwiftUI

struct DetailView: View {
    let schedule: Schedule
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Section {
                    Text(schedule.date ?? Date.now , style: .date)
                        .font(.title)
                    Text(schedule.date ?? Date.now , style: .time)
                        .font(.title)
                } header: {
                    Text("- Time")
                        .font(.headline)
                        .padding()
                }
                
                Section {
                    Text(schedule.design ?? "Unknown Design")
                        .font(.title)
                } header: {
                    Text("- Design")
                        .font(.headline)
                        .padding()
                }
                
                Section {
                    Text(schedule.comment ?? "Unknown Comment")
                        .font(.title)
                } header: {
                    Text("- Comment")
                        .font(.headline)
                        .padding()
                }
                
                Spacer()
            }
            .padding()
            .frame(width: 400, height: 600, alignment: .leading)
        }
        .navigationTitle(schedule.name ?? "Unknown Client")
        .navigationBarTitleDisplayMode(.large)
        .alert("Delete this Schedule?", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive, action: deleteSchedule)
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you really sure?")
        }
        .toolbar {
            Button {
                showingDeleteAlert = true
            } label: {
                Label("Delete the schedule", systemImage: "trash")
            }
        }
    }
    
    func deleteSchedule() {
        moc.delete(schedule)
        
        try? moc.save()
        
        dismiss()
    }
}

