//
//  Item.swift
//  SimpleShoppingList
//
//  Created by Jaejun Shin on 11/5/2022.
//

import Foundation

struct ShoppingItem: Identifiable, Codable {
    var id = UUID()
    var name: String
    var store: String
    var priority: String
}
