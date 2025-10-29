//
//  MainTabView.swift
//  TidyDay
//
//  Created by John Rediker on 10/28/25.
//

import SwiftUI

struct MainTabView: View {
    @State private var viewModel = TodoViewModel()
    @State private var settings = AppSettings()
    @State private var selectedTab: Tab = .home
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color(uiColor: .systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                if selectedTab != .home {
                    headerView
                }
                
                ZStack {
                    if selectedTab == .home {
                        HomeView(viewModel: $viewModel, settings: settings)
                            .transition(.move(edge: .leading))
                    } else if selectedTab == .tasks {
                        TasksListView(viewModel: $viewModel)
                            .transition(.move(edge: .trailing))
                    } else if selectedTab == .settings {
                        SettingsView(viewModel: $viewModel, settings: settings)
                            .transition(.move(edge: .trailing))
                    }
                }
                .animation(.easeInOut(duration: 0.25), value: selectedTab)
            }
            
            FloatingTabBar(selectedTab: $selectedTab)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text(headerTitle)
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 8)
        .padding(.bottom, 8)
        .animation(.easeInOut(duration: 0.25), value: selectedTab)
    }
    
    private var headerTitle: String {
        switch selectedTab {
        case .home:
            return "TidyDay"
        case .tasks:
            return "Tasks"
        case .settings:
            return "Settings"
        }
    }
}

#Preview {
    MainTabView()
}
