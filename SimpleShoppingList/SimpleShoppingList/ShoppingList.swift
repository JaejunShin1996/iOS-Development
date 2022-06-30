//
//  ShoppingList.swift
//  SimpleShoppingList
//
//  Created by Jaejun Shin on 11/5/2022.
//

import Foundation


class ShoppingList: ObservableObject {
    @Published var shoppingListItems = [ShoppingItem]() {
        didSet {
            let encoder = JSONEncoder()
            
            if let encoded = try? encoder.encode(shoppingListItems) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decoded = try? JSONDecoder().decode([ShoppingItem].self, from: savedItems) {
                shoppingListItems = decoded
                return
            }
        }
        shoppingListItems = []
    }
    
}
