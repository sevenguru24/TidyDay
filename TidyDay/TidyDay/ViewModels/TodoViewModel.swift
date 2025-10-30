//
//  TodoViewModel.swift
//  TidyDay
//
//  Created by John Rediker on 10/28/25.
//

import Foundation
import SwiftUI

@Observable
class TodoViewModel {
    var todos: [TodoItem] = []
    
    private let savePath = FileManager.documentsDirectory.appendingPathComponent("todos.json")
    
    init() {
        loadTodos()
    }
    
    func addTodo(title: String) {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let newTodo = TodoItem(title: title)
        todos.insert(newTodo, at: 0)
        saveTodos()
    }
    
    func addTodoWithGroceryList(title: String, groceryItems: [GroceryItem]) {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let newTodo = TodoItem(title: title, groceryItems: groceryItems)
        todos.insert(newTodo, at: 0)
        saveTodos()
    }
    
    func updateGroceryList(todo: TodoItem, title: String, groceryItems: [GroceryItem]) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            let oldTitle = todos[index].title
            todos[index].title = title
            todos[index].groceryItems = groceryItems
            
            // Add history entry if title changed
            if oldTitle != title {
                todos[index].addHistoryItem("Title updated from '\(oldTitle)' to '\(title)'")
            }
            todos[index].addHistoryItem("Grocery list updated")
            
            saveTodos()
        }
    }
    
    func addGroceryItem(_ todo: TodoItem, itemName: String) {
        if let todoIndex = todos.firstIndex(where: { $0.id == todo.id }),
           var items = todos[todoIndex].groceryItems {
            let newItem = GroceryItem(name: itemName)
            items.append(newItem)
            todos[todoIndex].groceryItems = items
            todos[todoIndex].addHistoryItem("Added item: \(itemName)")
            saveTodos()
        }
    }
    
    func toggleGroceryItem(_ todo: TodoItem, itemId: UUID) {
        if let todoIndex = todos.firstIndex(where: { $0.id == todo.id }),
           var items = todos[todoIndex].groceryItems,
           let itemIndex = items.firstIndex(where: { $0.id == itemId }) {
            let itemName = items[itemIndex].name
            let wasCompleted = items[itemIndex].isCompleted
            items[itemIndex].isCompleted.toggle()
            todos[todoIndex].groceryItems = items
            
            let action = wasCompleted ? "Unchecked item: \(itemName)" : "Checked item: \(itemName)"
            todos[todoIndex].addHistoryItem(action)
            
            saveTodos()
        }
    }
    
    func deleteGroceryItem(_ todo: TodoItem, itemId: UUID) {
        if let todoIndex = todos.firstIndex(where: { $0.id == todo.id }),
           var items = todos[todoIndex].groceryItems,
           let itemIndex = items.firstIndex(where: { $0.id == itemId }) {
            let itemName = items[itemIndex].name
            items.removeAll { $0.id == itemId }
            todos[todoIndex].groceryItems = items
            todos[todoIndex].addHistoryItem("Deleted item: \(itemName)")
            saveTodos()
        }
    }
    
    func toggleTodo(_ todo: TodoItem) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index].isCompleted.toggle()
            saveTodos()
        }
    }
    
    func toggleComplete(_ todo: TodoItem) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            let wasCompleted = todos[index].isCompleted
            todos[index].isCompleted.toggle()
            
            // Add history entry
            let action = wasCompleted ? "Marked as pending" : "Marked as completed"
            todos[index].addHistoryItem(action)
            
            saveTodos()
        }
    }
    
    func archiveTodo(_ todo: TodoItem) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index].isArchived = true
            saveTodos()
        }
    }
    
    func unarchiveTodo(_ todo: TodoItem) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index].isArchived = false
            saveTodos()
        }
    }
    
    func deleteTodo(_ todo: TodoItem) {
        todos.removeAll { $0.id == todo.id }
        saveTodos()
    }
    
    func saveTodos() {
        do {
            let data = try JSONEncoder().encode(todos)
            try data.write(to: savePath, options: [.atomic, .completeFileProtection])
        } catch {
            print("Unable to save todos: \(error.localizedDescription)")
        }
    }
    
    private func loadTodos() {
        do {
            let data = try Data(contentsOf: savePath)
            todos = try JSONDecoder().decode([TodoItem].self, from: data)
        } catch {
            todos = []
        }
        
        // Clear all existing todos for fresh start
        // Commented out to preserve existing todos
        // todos = []
        // saveTodos()
    }
}

extension FileManager {
    static var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
