//
//  GroceryListRowView.swift
//  TidyDay
//
//  Created by John Rediker on 10/28/25.
//

import SwiftUI

struct GroceryListRowView: View {
    let todo: TodoItem
    @Binding var viewModel: TodoViewModel
    let onEdit: () -> Void
    let onInfo: () -> Void
    let onDelete: () -> Void
    
    @State private var isExpanded = false
    @State private var newItemText = ""
    @FocusState private var isInputFocused: Bool
    @State private var dragOffset = CGSize.zero
    @State private var isShowingActions = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Main grocery list header with swipe actions
            ZStack {
                // Background action buttons
                HStack {
                    // Left side - Complete action (swipe right)
                    Button(action: {
                        let impact = UIImpactFeedbackGenerator(style: .medium)
                        impact.impactOccurred()
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            viewModel.toggleTodo(todo)
                        }
                    }) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.white)
                    }
                    .buttonStyle(.plain)
                    .frame(width: 60, height: 60)
                    .background(Color.green)
                    .opacity(dragOffset.width > 50 ? 1 : 0)
                    
                    Spacer()
                    
                    // Right side actions (swipe left)
                    HStack(spacing: 0) {
                        Button(action: onInfo) {
                            Image(systemName: "info.circle.fill")
                                .font(.system(size: 22))
                                .foregroundColor(.white)
                        }
                        .buttonStyle(.plain)
                        .frame(width: 60, height: 60)
                        .background(Color.blue)
                        
                        Button(action: onEdit) {
                            Image(systemName: "pencil.circle.fill")
                                .font(.system(size: 22))
                                .foregroundColor(.white)
                        }
                        .buttonStyle(.plain)
                        .frame(width: 60, height: 60)
                        .background(Color.orange)
                        
                        Button(action: onDelete) {
                            Image(systemName: "trash.circle.fill")
                                .font(.system(size: 22))
                                .foregroundColor(.white)
                        }
                        .buttonStyle(.plain)
                        .frame(width: 60, height: 60)
                        .background(Color.red)
                    }
                    .opacity(dragOffset.width < -50 ? 1 : 0)
                }
                
                // Main content
                HStack(spacing: 16) {
                    Image(systemName: "cart.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.green)
                        .frame(width: 24, height: 24)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(todo.title)
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(todo.isCompleted ? .secondary : .primary)
                            .strikethrough(todo.isCompleted, color: .secondary)
                        
                        if let items = todo.groceryItems {
                            let completedCount = items.filter { $0.isCompleted }.count
                            Text("\(completedCount)/\(items.count) items")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isExpanded.toggle()
                        }
                    }) {
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.secondary)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 16)
                .background(Color(UIColor.systemBackground))
                .offset(x: dragOffset.width)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            dragOffset = value.translation
                        }
                        .onEnded { value in
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                if value.translation.width < -100 {
                                    // Show right side actions
                                    dragOffset = CGSize(width: -180, height: 0)
                                    isShowingActions = true
                                } else if value.translation.width > 100 {
                                    // Show left side complete action
                                    dragOffset = CGSize(width: 60, height: 0)
                                    isShowingActions = true
                                } else {
                                    // Snap back
                                    dragOffset = .zero
                                    isShowingActions = false
                                }
                            }
                        }
                )
                .onTapGesture {
                    if isShowingActions {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            dragOffset = .zero
                            isShowingActions = false
                        }
                    } else {
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isExpanded.toggle()
                        }
                    }
                }
            }
            
            // Expanded grocery items
            if isExpanded {
                VStack(spacing: 12) {
                    // Add new item input
                    HStack(spacing: 12) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.blue)
                        
                        TextField("Add item...", text: $newItemText)
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.primary)
                            .focused($isInputFocused)
                            .submitLabel(.done)
                            .onSubmit {
                                addNewItem()
                            }
                        
                        if !newItemText.isEmpty {
                            Button(action: addNewItem) {
                                Image(systemName: "arrow.up.circle.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(.blue)
                            }
                            .buttonStyle(.plain)
                            .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                    
                    // Existing grocery items
                    if let items = todo.groceryItems {
                        ForEach(items) { item in
                            HStack(spacing: 16) {
                                Button(action: {
                                    let impact = UIImpactFeedbackGenerator(style: .light)
                                    impact.impactOccurred()
                                    
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        viewModel.toggleGroceryItem(todo, itemId: item.id)
                                    }
                                }) {
                                    ZStack {
                                        Circle()
                                            .stroke(item.isCompleted ? Color.clear : Color.secondary.opacity(0.3), lineWidth: 2)
                                            .frame(width: 20, height: 20)
                                        
                                        if item.isCompleted {
                                            Circle()
                                                .fill(Color.blue)
                                                .frame(width: 20, height: 20)
                                            
                                            Image(systemName: "checkmark")
                                                .font(.system(size: 10, weight: .bold))
                                                .foregroundColor(.white)
                                        }
                                    }
                                }
                                .buttonStyle(.plain)
                                
                                Text(item.name)
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(item.isCompleted ? .secondary : .primary)
                                    .strikethrough(item.isCompleted)
                                
                                Spacer()
                                
                                Button(action: {
                                    let impact = UIImpactFeedbackGenerator(style: .medium)
                                    impact.impactOccurred()
                                    
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        viewModel.deleteGroceryItem(todo, itemId: item.id)
                                    }
                                }) {
                                    Image(systemName: "trash.fill")
                                        .font(.system(size: 14))
                                        .foregroundColor(.red)
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(10)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 12)
                .transition(.opacity)
            }
        }
        .background(Color(UIColor.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
        .opacity(todo.isCompleted ? 0.6 : 1.0)
    }
    
    private func addNewItem() {
        guard !newItemText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            viewModel.addGroceryItem(todo, itemName: newItemText)
            newItemText = ""
        }
        
        isInputFocused = false
    }
}
