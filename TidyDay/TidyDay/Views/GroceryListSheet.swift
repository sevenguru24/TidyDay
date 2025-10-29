//
//  GroceryListSheet.swift
//  TidyDay
//
//  Created by John Rediker on 10/28/25.
//

import SwiftUI

struct GroceryListSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var viewModel: TodoViewModel
    var editingTodo: TodoItem?
    
    @State private var groceryListTitle = ""
    @State private var groceryItems: [GroceryItem] = []
    @State private var newItemText = ""
    @FocusState private var isItemInputFocused: Bool
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Title Input
                VStack(spacing: 16) {
                    HStack(spacing: 12) {
                        Image(systemName: "cart.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.green)
                        
                        TextField("Grocery List Name", text: $groceryListTitle)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(.regularMaterial)
                    }
                    
                    // Add Item Input
                    HStack(spacing: 12) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.blue)
                        
                        TextField("Add item...", text: $newItemText)
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.primary)
                            .focused($isItemInputFocused)
                            .submitLabel(.done)
                            .onSubmit {
                                addGroceryItem()
                            }
                        
                        if !newItemText.isEmpty {
                            Button(action: addGroceryItem) {
                                Image(systemName: "arrow.up.circle.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.blue)
                            }
                            .buttonStyle(.plain)
                            .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(.regularMaterial)
                    }
                }
                .padding()
                
                // Grocery Items List
                if !groceryItems.isEmpty {
                    ScrollView {
                        VStack(spacing: 8) {
                            ForEach(groceryItems) { item in
                                HStack(spacing: 12) {
                                    Button(action: {
                                        toggleItemComplete(item)
                                    }) {
                                        ZStack {
                                            Circle()
                                                .stroke(Color.blue, lineWidth: 2)
                                                .frame(width: 24, height: 24)
                                            
                                            if item.isCompleted {
                                                Circle()
                                                    .fill(Color.blue)
                                                    .frame(width: 24, height: 24)
                                                
                                                Image(systemName: "checkmark")
                                                    .font(.system(size: 12, weight: .bold))
                                                    .foregroundColor(.white)
                                            }
                                        }
                                    }
                                    .buttonStyle(.plain)
                                    
                                    Text(item.name)
                                        .font(.system(size: 17, weight: .regular))
                                        .foregroundColor(item.isCompleted ? .secondary : .primary)
                                        .strikethrough(item.isCompleted)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            deleteGroceryItem(item)
                                        }
                                    }) {
                                        Image(systemName: "trash.fill")
                                            .font(.system(size: 14))
                                            .foregroundColor(.red)
                                    }
                                    .buttonStyle(.plain)
                                }
                                .padding()
                                .background {
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .fill(.regularMaterial)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                } else {
                    Spacer()
                    
                    VStack(spacing: 16) {
                        Image(systemName: "cart.badge.plus")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)
                        
                        Text("No items yet")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.secondary)
                        
                        Text("Add items to your grocery list")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
            }
            .navigationTitle(editingTodo != nil ? "Edit Grocery List" : "New Grocery List")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveGroceryList()
                    }
                    .disabled(groceryListTitle.isEmpty || groceryItems.isEmpty)
                }
            }
            .onAppear {
                if let editing = editingTodo {
                    groceryListTitle = editing.title
                    groceryItems = editing.groceryItems ?? []
                }
            }
        }
    }
    
    private func addGroceryItem() {
        guard !newItemText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            groceryItems.append(GroceryItem(name: newItemText))
            newItemText = ""
        }
    }
    
    private func toggleItemComplete(_ item: GroceryItem) {
        if let index = groceryItems.firstIndex(where: { $0.id == item.id }) {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                groceryItems[index].isCompleted.toggle()
            }
        }
    }
    
    private func deleteGroceryItem(_ item: GroceryItem) {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        groceryItems.removeAll { $0.id == item.id }
    }
    
    private func saveGroceryList() {
        guard !groceryListTitle.isEmpty && !groceryItems.isEmpty else { return }
        
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        if let editing = editingTodo {
            // Update existing grocery list
            viewModel.updateGroceryList(
                todo: editing,
                title: groceryListTitle,
                groceryItems: groceryItems
            )
        } else {
            // Create new grocery list
            viewModel.addTodoWithGroceryList(
                title: groceryListTitle,
                groceryItems: groceryItems
            )
        }
        dismiss()
    }
}

// GroceryItem is now in TodoItem.swift
