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
                
                Section {
                    if todo.history.isEmpty {
                        Text("No history available")
                            .foregroundColor(.secondary)
                            .font(.system(size: 15))
                    } else {
                        ForEach(todo.history.reversed()) { historyItem in
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(historyItem.action)
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Text(historyItem.timestamp, style: .time)
                                        .font(.system(size: 13))
                                        .foregroundColor(.secondary)
                                }
                                Text(historyItem.timestamp, style: .date)
                                    .font(.system(size: 13))
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 2)
                        }
                    }
                } header: {
                    Text("History")
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
