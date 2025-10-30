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
    @State private var editedDueDate: Date?
    @State private var editedDueTime: Date?
    @State private var isDateExpanded = false
    @State private var isTimeExpanded = false
    let onSave: () -> Void
    let onDelete: () -> Void
    
    init(todo: Binding<TodoItem>, onSave: @escaping () -> Void, onDelete: @escaping () -> Void) {
        self._todo = todo
        self._editedTitle = State(initialValue: todo.wrappedValue.title)
        self._editingGroceryItems = State(initialValue: todo.wrappedValue.groceryItems ?? [])
        self._editedDueDate = State(initialValue: todo.wrappedValue.dueDate)
        self._editedDueTime = State(initialValue: todo.wrappedValue.dueTime)
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
                
                Section {
                    DisclosureGroup(
                        isExpanded: $isDateExpanded,
                        content: {
                            VStack(spacing: 8) {
                                DatePicker("Due Date", selection: Binding(
                                    get: { editedDueDate ?? Date() },
                                    set: { editedDueDate = $0 }
                                ), displayedComponents: .date)
                                .datePickerStyle(.graphical)
                                .labelsHidden()
                                
                                if editedDueDate != nil {
                                    Button(action: {
                                        editedDueDate = nil
                                        isDateExpanded = false
                                    }) {
                                        Text("Clear Date")
                                            .font(.system(size: 15))
                                            .foregroundColor(.red)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 8)
                                            .background(Color.red.opacity(0.1))
                                            .cornerRadius(8)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        },
                        label: {
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundColor(.secondary)
                                    .frame(width: 24)
                                Text("Due Date")
                                Spacer()
                                if let date = editedDueDate {
                                    Text(date.formatted(date: .abbreviated, time: .omitted))
                                        .foregroundColor(.secondary)
                                } else {
                                    Text("None")
                                        .foregroundColor(.secondary)
                                }
                            }
                            .contentShape(Rectangle())
                        }
                    )
                    
                    DisclosureGroup(
                        isExpanded: $isTimeExpanded,
                        content: {
                            VStack(spacing: 8) {
                                DatePicker("Due Time", selection: Binding(
                                    get: { editedDueTime ?? roundToNext15Minutes(Date()) },
                                    set: { editedDueTime = roundToNext15Minutes($0) }
                                ), displayedComponents: .hourAndMinute)
                                .datePickerStyle(.wheel)
                                .labelsHidden()
                                
                                if editedDueTime != nil {
                                    Button(action: {
                                        editedDueTime = nil
                                        isTimeExpanded = false
                                    }) {
                                        Text("Clear Time")
                                            .font(.system(size: 15))
                                            .foregroundColor(.red)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 8)
                                            .background(Color.red.opacity(0.1))
                                            .cornerRadius(8)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        },
                        label: {
                            HStack {
                                Image(systemName: "clock")
                                    .foregroundColor(.secondary)
                                    .frame(width: 24)
                                Text("Due Time")
                                Spacer()
                                if let time = editedDueTime {
                                    Text(time.formatted(date: .omitted, time: .shortened))
                                        .foregroundColor(.secondary)
                                } else {
                                    Text("None")
                                        .foregroundColor(.secondary)
                                }
                            }
                            .contentShape(Rectangle())
                        }
                    )
                } header: {
                    Text("Information")
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
                    Text("Metadata")
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
                            let oldTitle = todo.title
                            let oldDueDate = todo.dueDate
                            let oldDueTime = todo.dueTime
                            
                            todo.title = editedTitle
                            todo.dueDate = editedDueDate
                            todo.dueTime = editedDueTime
                            
                            // Track specific changes only
                            if oldTitle != editedTitle {
                                todo.addHistoryItem("Title updated from '\(oldTitle)' to '\(editedTitle)'")
                            }
                            
                            if oldDueDate != editedDueDate {
                                let oldDateStr = oldDueDate?.formatted(date: .abbreviated, time: .omitted) ?? "None"
                                let newDateStr = editedDueDate?.formatted(date: .abbreviated, time: .omitted) ?? "None"
                                todo.addHistoryItem("Due date changed from \(oldDateStr) to \(newDateStr)")
                            }
                            
                            if oldDueTime != editedDueTime {
                                let oldTimeStr = oldDueTime?.formatted(date: .omitted, time: .shortened) ?? "None"
                                let newTimeStr = editedDueTime?.formatted(date: .omitted, time: .shortened) ?? "None"
                                todo.addHistoryItem("Due time changed from \(oldTimeStr) to \(newTimeStr)")
                            }
                            
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
    
    private func roundToNext15Minutes(_ date: Date) -> Date {
        let calendar = Calendar.current
        let minutes = calendar.component(.minute, from: date)
        let roundedMinutes = (minutes / 15 + 1) * 15
        return calendar.date(bySetting: .minute, value: roundedMinutes % 60, of: date) ?? date
    }
}
