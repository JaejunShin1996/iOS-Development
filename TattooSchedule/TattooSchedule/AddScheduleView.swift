//
//  AddScheduleView.swift
//  TattooSchedule
//
//  Created by Jaejun Shin on 14/6/2022.
//

import SwiftUI

struct AddScheduleView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var date = Date()
    @State private var design = ""
    @State private var comment = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Client Name", text: $name)
                    
                    VStack {
                        DatePicker("Select the date", selection: $date)
                                    .datePickerStyle(GraphicalDatePickerStyle())
                        
                        Text(date.formatted(date: .abbreviated, time: .shortened))
                    }
                    
                }
                
                Section {
                    TextField("Design", text: $design)
                    
                    TextField("Any Comment?", text: $comment)
                } header: {
                    Text("Tattoo Detail")
                }
                
                Section {
                    Button("Save") {
                        let newSchedule = Schedule(context: moc)
                        newSchedule.id = UUID()
                        newSchedule.name = name
                        newSchedule.date = date
                        newSchedule.design = design
                        newSchedule.comment = comment
                        
                        try? moc.save()
                        dismiss()
                    }
                }
            }
            .navigationTitle("Add New Schedule")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Back")
                    }
                }
            }
        }
    }
}

struct AddScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        AddScheduleView()
    }
}
