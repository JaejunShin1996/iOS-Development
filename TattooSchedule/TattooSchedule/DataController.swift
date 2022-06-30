//
//  DataController.swift
//  TattooSchedule
//
//  Created by Jaejun Shin on 14/6/2022.
//
import CoreData
import Foundation

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "Schedule")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data Failed to load \(error.localizedDescription)")
            }
        }
    }
}
