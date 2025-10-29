//
//  HomeView.swift
//  TidyDay
//
//  Created by John Rediker on 10/28/25.
//

import SwiftUI

struct HomeView: View {
    @Binding var viewModel: TodoViewModel
    let settings: AppSettings
    let onNavigateToTasks: (TaskFilter) -> Void
    
    init(viewModel: Binding<TodoViewModel>, settings: AppSettings, onNavigateToTasks: @escaping (TaskFilter) -> Void = { _ in }) {
        self._viewModel = viewModel
        self.settings = settings
        self.onNavigateToTasks = onNavigateToTasks
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                greetingSection
                
                statsSection
                
                recentTasksSection
                
                quickStatsSection
            }
            .padding(.horizontal)
            .padding(.top, 8)
            .padding(.bottom, 80)
        }
    }
    
    @State private var selectedDate = Date()
    @State private var showingSearch = false
    @State private var showingNotifications = false
    private let calendar = Calendar.current
    
    private var greetingSection: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Hello")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.secondary)
                    Text("User 👋")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    Text(todayDate)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                HStack(spacing: 12) {
                    Button(action: {
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                        showingSearch = true
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.secondary.opacity(0.15))
                                .frame(width: 44, height: 44)
                            
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.primary)
                        }
                    }
                    .buttonStyle(.plain)
                    
                    Button(action: {
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                        showingNotifications = true
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.secondary.opacity(0.15))
                                .frame(width: 44, height: 44)
                            
                            Image(systemName: "bell.fill")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.primary)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    private var statsSection: some View {
        HStack(spacing: 12) {
            StatCard(
                title: "Total",
                value: "\(viewModel.todos.filter { !$0.isArchived }.count)",
                color: .blue,
                icon: "list.bullet",
                onTap: { onNavigateToTasks(.all) }
            )
            
            StatCard(
                title: "Completed",
                value: "\(completedCount)",
                color: .green,
                icon: "checkmark.circle.fill",
                onTap: { onNavigateToTasks(.completed) }
            )
            
            StatCard(
                title: "Pending",
                value: "\(pendingCount)",
                color: .orange,
                icon: "clock.fill",
                onTap: { onNavigateToTasks(.pending) }
            )
        }
        .padding(.horizontal, 8)
    }
    
    private var recentTasksSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recent Tasks")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Spacer()
                
                if viewModel.todos.filter({ !$0.isArchived }).count > 3 {
                    Text("\(viewModel.todos.filter({ !$0.isArchived }).count) total")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 8)
            
            if viewModel.todos.filter({ !$0.isArchived }).isEmpty {
                EmptyRecentView()
            } else {
                VStack(spacing: 0) {
                    ForEach(Array(viewModel.todos.filter({ !$0.isArchived }).prefix(5))) { todo in
                        RecentTaskRow(todo: todo)
                        
                        if todo.id != viewModel.todos.filter({ !$0.isArchived }).prefix(5).last?.id {
                            Divider()
                                .padding(.leading, 56)
                        }
                    }
                }
                .background {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(.regularMaterial)
                        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 4)
                        .overlay {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .strokeBorder(
                                    Color.primary.opacity(0.1),
                                    lineWidth: 0.5
                                )
                        }
                }
                .padding(.horizontal, 8)
            }
        }
    }
    
    private var quickStatsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Insights")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .padding(.horizontal, 8)
            
            VStack(spacing: 12) {
                InsightRow(
                    icon: "chart.bar.fill",
                    title: "Completion Rate",
                    value: completionRate,
                    color: .purple
                )
                
                InsightRow(
                    icon: "calendar",
                    title: "Tasks Created Today",
                    value: "\(tasksCreatedToday)",
                    color: .blue
                )
                
                InsightRow(
                    icon: "star.fill",
                    title: "Completed Today",
                    value: "\(completedToday)",
                    color: .yellow
                )
            }
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.regularMaterial)
                    .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 4)
                    .overlay {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .strokeBorder(
                                Color.primary.opacity(0.1),
                                lineWidth: 0.5
                            )
                    }
            }
            .padding(.horizontal, 8)
        }
    }
    
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12:
            return "Good Morning"
        case 12..<17:
            return "Good Afternoon"
        default:
            return "Good Evening"
        }
    }
    
    private var todayDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: Date())
    }
    
    private var completedCount: Int {
        viewModel.todos.filter { $0.isCompleted && !$0.isArchived }.count
    }
    
    private var pendingCount: Int {
        viewModel.todos.filter { !$0.isCompleted && !$0.isArchived }.count
    }
    
    private var completionRate: String {
        let activeTodos = viewModel.todos.filter { !$0.isArchived }
        guard !activeTodos.isEmpty else { return "0%" }
        let rate = (Double(completedCount) / Double(activeTodos.count)) * 100
        return String(format: "%.0f%%", rate)
    }
    
    private var tasksCreatedToday: Int {
        let today = Calendar.current.startOfDay(for: Date())
        return viewModel.todos.filter { 
            !$0.isArchived && Calendar.current.isDate($0.createdAt, inSameDayAs: today) 
        }.count
    }
    
    private var completedToday: Int {
        let today = Calendar.current.startOfDay(for: Date())
        return viewModel.todos.filter {
            $0.isCompleted && !$0.isArchived && Calendar.current.isDate($0.createdAt, inSameDayAs: today)
        }.count
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    let icon: String
    let onTap: (() -> Void)?
    
    init(title: String, value: String, color: Color, icon: String, onTap: (() -> Void)? = nil) {
        self.title = title
        self.value = value
        self.color = color
        self.icon = icon
        self.onTap = onTap
    }
    
    var body: some View {
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            onTap?()
        }) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
                
                Text(value)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text(title)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.regularMaterial)
                    .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 4)
                    .overlay {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .strokeBorder(
                                Color.primary.opacity(0.1),
                                lineWidth: 0.5
                            )
                    }
            }
        }
        .buttonStyle(.plain)
    }
}

struct RecentTaskRow: View {
    let todo: TodoItem
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .stroke(todo.isCompleted ? Color.clear : Color.secondary.opacity(0.3), lineWidth: 2)
                    .frame(width: 24, height: 24)
                
                if todo.isCompleted {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 24, height: 24)
                    
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(todo.title)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(todo.isCompleted ? .secondary : .primary)
                    .strikethrough(todo.isCompleted, color: .secondary)
                    .lineLimit(2)
                
                Text(timeAgo(from: todo.createdAt))
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(uiColor: .systemBackground))
    }
    
    private func timeAgo(from date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.minute, .hour, .day], from: date, to: now)
        
        if let day = components.day, day > 0 {
            return day == 1 ? "Yesterday" : "\(day) days ago"
        } else if let hour = components.hour, hour > 0 {
            return hour == 1 ? "1 hour ago" : "\(hour) hours ago"
        } else if let minute = components.minute, minute > 0 {
            return minute == 1 ? "1 minute ago" : "\(minute) minutes ago"
        } else {
            return "Just now"
        }
    }
}

struct EmptyRecentView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "tray")
                .font(.system(size: 48))
                .foregroundColor(.secondary.opacity(0.6))
            
            Text("No tasks yet")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.secondary)
            
            Text("Create your first task to get started")
                .font(.system(size: 15))
                .foregroundColor(.secondary.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
        .background {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.regularMaterial)
                .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 4)
        }
        .padding(.horizontal, 8)
    }
}

struct InsightRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 44, height: 44)
                
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.primary)
                
                Text(value)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(uiColor: .systemBackground))
        )
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

struct DateButton: View {
    let date: Date
    let isSelected: Bool
    let action: () -> Void
    
    private var dayName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
    
    private var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Text(dayName)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(isSelected ? .white : .secondary)
                
                Text(dayNumber)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(isSelected ? .white : .primary)
            }
            .frame(width: 60, height: 70)
            .background {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(isSelected ? Color.blue : Color.secondary.opacity(0.1))
            }
        }
        .buttonStyle(.plain)
    }
}

