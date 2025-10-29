//
//  SettingsView.swift
//  TidyDay
//
//  Created by John Rediker on 10/28/25.
//

import SwiftUI

struct SettingsView: View {
    @Binding var viewModel: TodoViewModel
    @State var settings: AppSettings
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                profileSection
                
                preferencesSection
                
                dataSection
                
                aboutSection
            }
            .padding()
            .padding(.bottom, 80)
        }
    }
    
    private var profileSection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.blue, Color.blue.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                
                Text("U")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
            
            Text("User")
                .font(.system(size: 24, weight: .semibold, design: .rounded))
                .foregroundColor(.primary)
            
            Text("user@example.com")
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }
    
    private var preferencesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Preferences")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .padding(.horizontal, 8)
            
            VStack(spacing: 0) {
                SettingsRow(
                    icon: "bell.fill",
                    title: "Notifications",
                    color: .orange,
                    showChevron: true
                ) {}
                
                Divider()
                    .padding(.leading, 56)
                
                SettingsRow(
                    icon: "speaker.wave.2.fill",
                    title: "Sounds & Haptics",
                    color: .pink,
                    showChevron: true
                ) {}
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
    
    private var dataSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Data")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .padding(.horizontal, 8)
            
            VStack(spacing: 0) {
                SettingsRow(
                    icon: "arrow.down.circle.fill",
                    title: "Export Data",
                    color: .blue,
                    showChevron: true
                ) {}
                
                Divider()
                    .padding(.leading, 56)
                
                SettingsRow(
                    icon: "trash.fill",
                    title: "Clear All Tasks",
                    color: .red,
                    showChevron: false
                ) {
                    // Clear all tasks
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
    
    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("About")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .padding(.horizontal, 8)
            
            VStack(spacing: 0) {
                SettingsRow(
                    icon: "info.circle.fill",
                    title: "App Version",
                    color: .gray,
                    showChevron: false,
                    trailing: {
                        Text("1.0.0")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.secondary)
                    }
                ) {}
                
                Divider()
                    .padding(.leading, 56)
                
                SettingsRow(
                    icon: "heart.fill",
                    title: "Rate TidyDay",
                    color: .red,
                    showChevron: true
                ) {}
                
                Divider()
                    .padding(.leading, 56)
                
                SettingsRow(
                    icon: "square.and.arrow.up.fill",
                    title: "Share App",
                    color: .green,
                    showChevron: true
                ) {}
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

struct SettingsRow<Trailing: View>: View {
    let icon: String
    let title: String
    let color: Color
    let showChevron: Bool
    let trailing: () -> Trailing
    let action: () -> Void
    
    init(
        icon: String,
        title: String,
        color: Color,
        showChevron: Bool,
        @ViewBuilder trailing: @escaping () -> Trailing = { EmptyView() },
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.title = title
        self.color = color
        self.showChevron = showChevron
        self.trailing = trailing
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            action()
        }) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.primary)
                
                Spacer()
                
                trailing()
                
                if showChevron {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.secondary.opacity(0.5))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(uiColor: .systemBackground))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
