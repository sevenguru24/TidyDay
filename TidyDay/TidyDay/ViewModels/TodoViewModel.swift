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
    
    func toggleComplete(_ todo: TodoItem) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index].isCompleted.toggle()
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
        todos = []
        saveTodos()
    }
}

extension FileManager {
    static var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
