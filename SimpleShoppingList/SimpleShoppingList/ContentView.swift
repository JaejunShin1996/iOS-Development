//
//  ContentView.swift
//  SimpleShoppingList
//
//  Created by Jaejun Shin on 11/5/2022.
//

import SwiftUI


struct ContentView: View {
    @StateObject private var shoppingList = ShoppingList()
    
    @State private var showingAddView = false
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Red").foregroundColor(.red)) {
                    ForEach(shoppingList.shoppingListItems) { item in
                        let priority = item.priority
                        if priority == "Red" {
                            HStack {
                                VStack {
                                    Text(item.name)
                                        .font(.title)
                                    
                                    Text(item.priority)
                                }
                                Spacer()
                                
                                Text(item.store)
                            }
                        }
                    }
                    .onDelete(perform: removeItem)
                }
                Section(header: Text("Blue").foregroundColor(.blue)) {
                    ForEach(shoppingList.shoppingListItems) { item in
                        let priority = item.priority
                        if priority == "Blue" {
                            HStack {
                                VStack {
                                    Text(item.name)
                                        .font(.title)
                                    
                                    Text(item.priority)
                                }
                                Spacer()
                                
                                Text(item.store)
                            }
                        }
                    }
                    .onDelete(perform: removeItem)
                }
                Section(header: Text("Green").foregroundColor(.green)) {
                    ForEach(shoppingList.shoppingListItems) { item in
                        let priority = item.priority
                        if priority == "Green" {
                            HStack {
                                VStack {
                                    Text(item.name)
                                        .font(.title)
                                    
                                    Text(item.priority)
                                }
                                Spacer()
                                
                                Text(item.store)
                            }
                        }
                    }
                    .onDelete(perform: removeItem)
                }
            }
            .navigationTitle("Shopping List")
            
            .toolbar {
                Button {
                    showingAddView = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            
            .sheet(isPresented: $showingAddView) {
                Addnew(shoppingList: shoppingList)
            }
        }
    }
    
    func removeItem(at offsets: IndexSet) {
        shoppingList.shoppingListItems.remove(atOffsets: offsets)
    }

}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
