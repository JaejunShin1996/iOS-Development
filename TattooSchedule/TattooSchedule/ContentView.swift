//
//  ContentView.swift
//  TattooSchedule
//
//  Created by Jaejun Shin on 14/6/2022.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date)]) var schedules: FetchedResults<Schedule>
    
    @State private var showingAddSchedule = false
    
    
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Today").font(.largeTitle)) {
                    ForEach(schedules) { schedule in
                        if isToday(schedule: schedule) {
                            NavigationLink {
                                DetailView(schedule: schedule)
                            } label: {
                                VStack(alignment: .leading) {
                                    Text(schedule.name ?? "Unknown Client")
                                        .font(.largeTitle)
                                    
                                    Text(schedule.date?.formatted() ?? "Unknown date")
                                        .font(.title)
                                }
                            }
                        }
                    }
                }
                
                Section(header: Text("Incoming").font(.title)) {
                    ForEach(schedules) { schedule in
                        if schedule.date! > Date.now.addingTimeInterval(10000) {
                            NavigationLink {
                                DetailView(schedule: schedule)
                            } label: {
                                VStack(alignment: .leading) {
                                    Text(schedule.name ?? "Unknown Client")
                                        .font(.title)
                                    
                                    Text(schedule.date?.formatted() ?? "Unknown date")
                                        .font(.title)
                                }
                            }
                        }
                    }
                }
                
                Section(header: Text("Past").font(.title)) {
                    ForEach(schedules) { schedule in
                        if !isToday(schedule: schedule) && schedule.date! < Date.now.addingTimeInterval(10000) {
                            NavigationLink {
                                DetailView(schedule: schedule)
                            } label: {
                                VStack(alignment: .leading) {
                                    Text(schedule.name ?? "Unknown Client")
                                        .font(.title3)
                                        .foregroundColor(.secondary)
                                    
                                    Text(schedule.date?.formatted() ?? "Unknown date")
                                        .font(.headline)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Tattoo Schedule")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddSchedule.toggle()
                    } label: {
                        Label("Add Schedule", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddSchedule) {
                AddScheduleView()
            }
        }
    }
    
    func isToday(schedule: Schedule) -> Bool {
        let first = Date.now
        let second = schedule.date!

        return Calendar.current.isDate(first, equalTo: second, toGranularity: .day)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
