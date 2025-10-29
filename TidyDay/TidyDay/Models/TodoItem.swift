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
    
    init(id: UUID = UUID(), title: String, isCompleted: Bool = false, createdAt: Date = Date(), dueDate: Date? = nil, dueTime: Date? = nil) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.dueDate = dueDate
        self.dueTime = dueTime
    }
}
