//
//  Addnew.swift
//  SimpleShoppingList
//
//  Created by Jaejun Shin on 11/5/2022.
//

import SwiftUI

struct Addnew: View {
    @ObservedObject var shoppingList: ShoppingList
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var store = ""
    @State private var priority = ""
    
    let priorities = ["Red", "Blue", "Green"]
    
    var body: some View {
        NavigationView {
            List {
                TextField("Name", text: $name)
                
                TextField("Store", text: $store)
                
                Picker("Priority", selection: $priority) {
                    ForEach(priorities, id: \.self) {
                        Text($0)
                    }
                }
            }
            .navigationTitle("Add New Item")
            .toolbar {
                Button("Save") {
                    let newItem = ShoppingItem(name: name, store: store, priority: priority)
                    shoppingList.shoppingListItems.append(newItem)
                    dismiss()
                }
            }
        }
    }
}

struct Addnew_Previews: PreviewProvider {
    static var previews: some View {
        Addnew(shoppingList: ShoppingList())
    }
}
