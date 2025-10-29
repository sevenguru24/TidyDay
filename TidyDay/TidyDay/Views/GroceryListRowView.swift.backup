//
//  TodoRowView.swift
//  TidyDay
//
//  Created by John Rediker on 10/28/25.
//

import SwiftUI

struct TodoRowView: View {
    let todo: TodoItem
    let onToggle: () -> Void
    
    @State private var isPressed = false
    @State private var showCheckmark = false
    
    var body: some View {
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            
            isPressed = true
            
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                onToggle()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation {
                    isPressed = false
                }
            }
        }) {
            HStack(spacing: 16) {
                checkboxView
                
                Text(todo.title)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(todo.isCompleted ? .secondary : .primary)
                    .strikethrough(todo.isCompleted, color: .secondary)
                    .animation(.easeInOut(duration: 0.2), value: todo.isCompleted)
                    .multilineTextAlignment(.leading)
                
                Spacer(minLength: 0)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 16)
        }
        .buttonStyle(.plain)
        .onAppear {
            showCheckmark = todo.isCompleted
        }
    }
    
    private var checkboxView: some View {
        ZStack {
            Circle()
                .stroke(todo.isCompleted ? Color.clear : Color.secondary.opacity(0.3), lineWidth: 2)
                .frame(width: 24, height: 24)
            
            if todo.isCompleted {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 24, height: 24)
                    .scaleEffect(showCheckmark ? 1.0 : 0.01)
                    .onChange(of: todo.isCompleted) { oldValue, newValue in
                        if newValue {
                            showCheckmark = false
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.5)) {
                                showCheckmark = true
                            }
                        } else {
                            showCheckmark = false
                        }
                    }
                    .onAppear {
                        if todo.isCompleted {
                            showCheckmark = true
                        }
                    }
                
                Image(systemName: "checkmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
                    .scaleEffect(showCheckmark ? 1.0 : 0.01)
                    .opacity(showCheckmark ? 1.0 : 0.0)
            }
        }
    }
}
