//
//  EditTodoSheet.swift
//  TidyDay
//
//  Created by John Rediker on 10/28/25.
//

import SwiftUI

struct EditTodoSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var todo: TodoItem
    @State private var editedTitle: String
    @State private var editingGroceryItems: [GroceryItem]
    @State private var newGroceryItemName = ""
    let onSave: () -> Void
    let onDelete: () -> Void
    
    init(todo: Binding<TodoItem>, onSave: @escaping () -> Void, onDelete: @escaping () -> Void) {
        self._todo = todo
        self._editedTitle = State(initialValue: todo.wrappedValue.title)
        self._editingGroceryItems = State(initialValue: todo.wrappedValue.groceryItems ?? [])
        self.onSave = onSave
        self.onDelete = onDelete
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Task", text: $editedTitle, axis: .vertical)
                        .font(.system(size: 17))
                        .lineLimit(3...6)
                } header: {
                    Text("Details")
                }
                
                if todo.isGroceryList {
                    Section {
                        ForEach($editingGroceryItems) { $item in
                            HStack {
                                TextField("Item name", text: $item.name)
                                    .font(.system(size: 15))
                                
                                Button(action: {
                                    editingGroceryItems.removeAll { $0.id == item.id }
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(.red)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        
                        HStack {
                            TextField("Add item", text: $newGroceryItemName)
                                .font(.system(size: 15))
                                .onSubmit {
                                    addGroceryItem()
                                }
                            
                            if !newGroceryItemName.isEmpty {
                                Button(action: addGroceryItem) {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(.blue)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    } header: {
                        Text("Grocery Items")
                    }
                }
                
                Section {
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.secondary)
                            .frame(width: 24)
                        Text("Created")
                            .foregroundColor(.primary)
                        Spacer()
                        Text(todo.createdAt, style: .date)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.secondary)
                            .frame(width: 24)
                        Text("Time")
                        Spacer()
                        Text(todo.createdAt, style: .time)
                            .foregroundColor(.secondary)
                    }
                } header: {
                    Text("Information")
                }
                
                Section {
                    Button(role: .destructive, action: {
                        let impact = UIImpactFeedbackGenerator(style: .medium)
                        impact.impactOccurred()
                        dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            onDelete()
                        }
                    }) {
                        HStack {
                            Spacer()
                            Label("Delete Task", systemImage: "trash")
                                .font(.system(size: 17, weight: .semibold))
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Edit Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        if !editedTitle.trimmingCharacters(in: .whitespaces).isEmpty {
                            todo.title = editedTitle
                            if todo.isGroceryList {
                                todo.groceryItems = editingGroceryItems
                            }
                        }
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                        onSave()
                        dismiss()
                    }
                    .disabled(editedTitle.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
    
    private func addGroceryItem() {
        guard !newGroceryItemName.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let newItem = GroceryItem(name: newGroceryItemName)
        editingGroceryItems.append(newItem)
        newGroceryItemName = ""
    }
}
