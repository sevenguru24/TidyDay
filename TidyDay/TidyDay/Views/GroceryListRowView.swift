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
                    Spacer()
                    
                    // Left side actions
                    HStack(spacing: 16) {
                        Button(action: {
                            let impact = UIImpactFeedbackGenerator(style: .medium)
                            impact.impactOccurred()
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                viewModel.toggleTodo(todo)
                            }
                        }) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.green)
                        }
                        .buttonStyle(.plain)
                        
                        Button(action: onInfo) {
                            Image(systemName: "info.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.blue)
                        }
                        .buttonStyle(.plain)
                        
                        Button(action: onEdit) {
                            Image(systemName: "pencil.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.orange)
                        }
                        .buttonStyle(.plain)
                        
                        Button(action: onDelete) {
                            Image(systemName: "trash.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.red)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.trailing, 16)
                    .opacity(dragOffset.width < -50 ? 1 : 0)
                }
                
                // Main content
                HStack(spacing: 12) {
                    Image(systemName: "cart.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.green)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(todo.title)
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(.primary)
                            .strikethrough(todo.isCompleted)
                        
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
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(.regularMaterial)
                )
                .offset(x: dragOffset.width)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            dragOffset = value.translation
                        }
                        .onEnded { value in
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                if value.translation.width < -100 {
                                    // Keep showing actions
                                    dragOffset = CGSize(width: -120, height: 0)
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
                VStack(spacing: 8) {
                    // Add new item input
                    HStack(spacing: 12) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.blue)
                        
                        TextField("Add item...", text: $newItemText)
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.primary)
                            .focused($isInputFocused)
                            .submitLabel(.done)
                            .onSubmit {
                                addNewItem()
                            }
                        
                        if !newItemText.isEmpty {
                            Button(action: addNewItem) {
                                Image(systemName: "arrow.up.circle.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(.blue)
                            }
                            .buttonStyle(.plain)
                            .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.thickMaterial)
                            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    
                    // Existing grocery items
                    if let items = todo.groceryItems {
                        ForEach(items) { item in
                            HStack(spacing: 12) {
                                Button(action: {
                                    let impact = UIImpactFeedbackGenerator(style: .light)
                                    impact.impactOccurred()
                                    
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        viewModel.toggleGroceryItem(todo, itemId: item.id)
                                    }
                                }) {
                                    ZStack {
                                        Circle()
                                            .stroke(Color.blue, lineWidth: 2)
                                            .frame(width: 20, height: 20)
                                        
                                        if item.isCompleted {
                                            Circle()
                                                .fill(Color.blue)
                                                .frame(width: 20, height: 20)
                                                .scaleEffect(item.isCompleted ? 1.0 : 0.0)
                                            
                                            Image(systemName: "checkmark")
                                                .font(.system(size: 10, weight: .bold))
                                                .foregroundColor(.white)
                                        }
                                    }
                                }
                                .buttonStyle(.plain)
                                
                                Text(item.name)
                                    .font(.system(size: 15, weight: .regular))
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
                                        .font(.system(size: 12))
                                        .foregroundColor(.red)
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(.regularMaterial)
                                    .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 1)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 12)
                .clipped()
                .transition(.opacity.combined(with: .slide))
            }
        }
        .background(
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
        )
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
