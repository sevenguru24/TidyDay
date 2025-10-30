//
//  TodoItem.swift
//  TidyDay
//
//  Created by John Rediker on 10/28/25.
//

import Foundation

struct TodoItem: Identifiable, Codable {
    let id: UUID
    var title: String
    var isCompleted: Bool
    var createdAt: Date
    var dueDate: Date?
    var dueTime: Date?
    var groceryItems: [GroceryItem]?
    var isArchived: Bool
    var history: [TodoHistoryItem]
    var isGroceryList: Bool {
        groceryItems != nil
    }
    
    init(id: UUID = UUID(), title: String, isCompleted: Bool = false, createdAt: Date = Date(), dueDate: Date? = nil, dueTime: Date? = nil, groceryItems: [GroceryItem]? = nil, isArchived: Bool = false) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.dueDate = dueDate
        self.dueTime = dueTime
        self.groceryItems = groceryItems
        self.isArchived = isArchived
        self.history = [TodoHistoryItem(action: "Created", timestamp: createdAt)]
    }
    
    mutating func addHistoryItem(_ action: String) {
        history.append(TodoHistoryItem(action: action, timestamp: Date()))
    }
}

struct GroceryItem: Identifiable, Codable {
    let id: UUID
    var name: String
    var isCompleted: Bool
    
    init(id: UUID = UUID(), name: String, isCompleted: Bool = false) {
        self.id = id
        self.name = name
        self.isCompleted = isCompleted
    }
}

struct TodoHistoryItem: Identifiable, Codable {
    let id: UUID
    let action: String
    let timestamp: Date
    
    init(id: UUID = UUID(), action: String, timestamp: Date) {
        self.id = id
        self.action = action
        self.timestamp = timestamp
    }
}
