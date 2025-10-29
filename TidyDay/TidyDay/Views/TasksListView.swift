//
//  TasksListView.swift
//  TidyDay
//
//  Created by John Rediker on 10/28/25.
//

import SwiftUI

struct TasksListView: View {
    @Binding var viewModel: TodoViewModel
    @State private var newTodoText = ""
    @FocusState private var isInputFocused: Bool
    @State private var editingTodo: TodoItem?
    @State private var showingInfo: TodoItem?
    @State private var showDateTimePickers = false
    @State private var selectedDueDate: Date?
    @State private var selectedDueTime: Date?
    @State private var showDatePicker = false
    @State private var showTimePicker = false
    @State private var showGroceryListSheet = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Plus Button and Text Box - Inline
            HStack(alignment: .top, spacing: 12) {
                Menu {
                    Button(action: {
                        showGroceryListSheet = true
                    }) {
                        Label("Grocery List", systemImage: "cart.fill")
                    }
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.blue)
                }
                .padding(.top, 12)
                
                inputCardView
            }
            .padding(.horizontal)
            .padding(.vertical)
            
            if !viewModel.todos.isEmpty {
                List {
                    ForEach(viewModel.todos) { todo in
                        if todo.isGroceryList {
                            GroceryListRowView(
                                todo: todo,
                                viewModel: $viewModel,
                                onEdit: { editingTodo = todo },
                                onInfo: { showingInfo = todo },
                                onDelete: {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        viewModel.deleteTodo(todo)
                                    }
                                }
                            )
                            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        viewModel.deleteTodo(todo)
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash.fill")
                                }
                                
                                Button {
                                    showingInfo = todo
                                } label: {
                                    Label("Info", systemImage: "info.circle.fill")
                                }
                                .tint(.blue)
                                
                                Button {
                                    editingTodo = todo
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }
                                .tint(.orange)
                            }
                            .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                Button {
                                    let impact = UIImpactFeedbackGenerator(style: .medium)
                                    impact.impactOccurred()
                                    
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                        viewModel.toggleComplete(todo)
                                    }
                                } label: {
                                    Label("Complete", systemImage: "checkmark.circle.fill")
                                }
                                .tint(.green)
                            }
                            .contextMenu {
                                Button {
                                    editingTodo = todo
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }
                                
                                Button {
                                    showingInfo = todo
                                } label: {
                                    Label("Info", systemImage: "info.circle")
                                }
                                
                                Button(role: .destructive) {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        viewModel.deleteTodo(todo)
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        } else {
                            TodoRowView(todo: todo) {
                                viewModel.toggleComplete(todo)
                            }
                            .background {
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(.regularMaterial)
                                    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .strokeBorder(
                                                Color.primary.opacity(0.08),
                                                lineWidth: 0.5
                                            )
                                    }
                            }
                            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        viewModel.deleteTodo(todo)
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash.fill")
                                }
                                
                                Button {
                                    showingInfo = todo
                                } label: {
                                    Label("Info", systemImage: "info.circle.fill")
                                }
                                .tint(.blue)
                                
                                Button {
                                    editingTodo = todo
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }
                                .tint(.orange)
                            }
                            .contextMenu {
                                Button {
                                    editingTodo = todo
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }
                                
                                Button {
                                    showingInfo = todo
                                } label: {
                                    Label("Info", systemImage: "info.circle")
                                }
                                
                                Button(role: .destructive) {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        viewModel.deleteTodo(todo)
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            let todo = viewModel.todos[index]
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                viewModel.deleteTodo(todo)
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            } else {
                ScrollView {
                    emptyStateView
                }
            }
        }
        .sheet(item: $editingTodo) { todo in
            if let index = viewModel.todos.firstIndex(where: { $0.id == todo.id }) {
                if todo.isGroceryList {
                    GroceryListSheet(viewModel: $viewModel, editingTodo: todo)
                } else {
                    EditTodoSheet(
                        todo: $viewModel.todos[index],
                        onSave: {
                            viewModel.saveTodos()
                        },
                        onDelete: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                viewModel.deleteTodo(todo)
                            }
                        }
                    )
                }
            }
        }
        .sheet(item: $showingInfo) { todo in
            TodoInfoSheet(todo: todo)
        }
        .sheet(isPresented: $showGroceryListSheet) {
            GroceryListSheet(viewModel: $viewModel)
        }
    }
    
    private var todosSummary: String {
        let total = viewModel.todos.count
        let completed = viewModel.todos.filter { $0.isCompleted }.count
        
        if completed == total {
            return "All tasks completed! 🎉"
        } else {
            return "\(completed) of \(total) completed"
        }
    }
    
    private var inputCardView: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                TextField("Add a new task...", text: $newTodoText)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.primary)
                    .focused($isInputFocused)
                    .submitLabel(.done)
                    .onSubmit {
                        addTodo()
                    }
                    .onChange(of: isInputFocused) { oldValue, newValue in
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            showDateTimePickers = newValue
                        }
                    }
                
                if !newTodoText.isEmpty {
                    Button(action: addTodo) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.blue)
                    }
                    .buttonStyle(.plain)
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.regularMaterial)
                    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
            }
            
            if showDateTimePickers {
                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                showDatePicker.toggle()
                                if showDatePicker {
                                    showTimePicker = false
                                }
                            }
                        }) {
                            HStack {
                                Image(systemName: showDatePicker ? "calendar.badge.minus" : "calendar.badge.plus")
                                    .font(.system(size: 16, weight: .medium))
                                Text(selectedDueDate != nil ? formattedDate(selectedDueDate!) : "Add Date")
                                    .font(.system(size: 15, weight: .medium))
                            }
                            .foregroundColor(selectedDueDate != nil ? .blue : .secondary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background {
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(Color.secondary.opacity(0.1))
                            }
                        }
                        .buttonStyle(.plain)
                        
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                showTimePicker.toggle()
                                if showTimePicker {
                                    showDatePicker = false
                                }
                            }
                        }) {
                            HStack {
                                Image(systemName: showTimePicker ? "clock.badge.minus" : "clock.badge.plus")
                                    .font(.system(size: 16, weight: .medium))
                                Text(selectedDueTime != nil ? formattedTime(selectedDueTime!) : "Add Time")
                                    .font(.system(size: 15, weight: .medium))
                            }
                            .foregroundColor(selectedDueTime != nil ? .blue : .secondary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background {
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(Color.secondary.opacity(0.1))
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    
                    if showDatePicker {
                        DatePicker("", selection: Binding(
                            get: { selectedDueDate ?? Date() },
                            set: { selectedDueDate = $0 }
                        ), displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                        .transition(.scale.combined(with: .opacity))
                    }
                    
                    if showTimePicker {
                        DatePicker("", selection: Binding(
                            get: { selectedDueTime ?? Date() },
                            set: { selectedDueTime = $0 }
                        ), displayedComponents: .hourAndMinute)
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        .transition(.scale.combined(with: .opacity))
                    }
                    
                    HStack(spacing: 12) {
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                showDateTimePickers = false
                                showDatePicker = false
                                showTimePicker = false
                                selectedDueDate = nil
                                selectedDueTime = nil
                                newTodoText = ""
                                isInputFocused = false
                            }
                        }) {
                            Text("Cancel")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background {
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .fill(Color.secondary.opacity(0.1))
                                }
                        }
                        .buttonStyle(.plain)
                        
                        Button(action: addTodo) {
                            Text("Add Task")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background {
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .fill(newTodoText.isEmpty ? Color.gray : Color.blue)
                                }
                        }
                        .buttonStyle(.plain)
                        .disabled(newTodoText.isEmpty)
                    }
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(.regularMaterial)
                        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: showDateTimePickers)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: showDatePicker)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: showTimePicker)
    }
    

    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.circle")
                .font(.system(size: 64))
                .foregroundColor(.blue)
                .padding(.top, 60)
            
            Text("All Clear!")
                .font(.system(size: 24, weight: .semibold, design: .rounded))
                .foregroundColor(.primary)
            
            Text("Add your first task to get started")
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .transition(.opacity)
    }
    
    private func addTodo() {
        guard !newTodoText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            let newTodo = TodoItem(
                title: newTodoText,
                dueDate: selectedDueDate,
                dueTime: selectedDueTime
            )
            viewModel.todos.insert(newTodo, at: 0)
            viewModel.saveTodos()
            
            newTodoText = ""
            showDateTimePickers = false
            showDatePicker = false
            showTimePicker = false
            selectedDueDate = nil
            selectedDueTime = nil
        }
        
        isInputFocused = false
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
