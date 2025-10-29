//
//  TodoInfoSheet.swift
//  TidyDay
//
//  Created by John Rediker on 10/28/25.
//

import SwiftUI

struct TodoInfoSheet: View {
    @Environment(\.dismiss) private var dismiss
    let todo: TodoItem
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Text("Title")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(todo.title)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Status")
                            .foregroundColor(.secondary)
                        Spacer()
                        HStack(spacing: 6) {
                            Circle()
                                .fill(todo.isCompleted ? Color.green : Color.orange)
                                .frame(width: 8, height: 8)
                            Text(todo.isCompleted ? "Completed" : "Pending")
                                .foregroundColor(.primary)
                        }
                    }
                } header: {
                    Text("Task Details")
                }
                
                Section {
                    HStack {
                        Text("Created")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(todo.createdAt, style: .date)
                            .foregroundColor(.primary)
                    }
                    
                    HStack {
                        Text("Time")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(todo.createdAt, style: .time)
                            .foregroundColor(.primary)
                    }
                    
                    HStack {
                        Text("ID")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(todo.id.uuidString.prefix(8) + "...")
                            .foregroundColor(.primary)
                            .font(.system(.body, design: .monospaced))
                    }
                } header: {
                    Text("Metadata")
                }
            }
            .navigationTitle("Task Info")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
