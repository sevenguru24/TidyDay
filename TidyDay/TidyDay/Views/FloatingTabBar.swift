//
//  FloatingTabBar.swift
//  TidyDay
//
//  Created by John Rediker on 10/28/25.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case home = "house.fill"
    case tasks = "list.bullet"
    case settings = "gearshape.fill"
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .tasks:
            return "Tasks"
        case .settings:
            return "Settings"
        }
    }
}

struct FloatingTabBar: View {
    @Binding var selectedTab: Tab
    let settings: AppSettings
    @Namespace private var animation
    @State private var tabHoverStates: [Tab: Bool] = [:]
    
    var body: some View {
        HStack(spacing: 16) {
            ForEach(Tab.allCases, id: \.self) { tab in
                TabButton(
                    tab: tab,
                    isSelected: selectedTab == tab,
                    isHovered: tabHoverStates[tab] ?? false,
                    namespace: animation
                ) {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.65)) {
                        selectedTab = tab
                    }
                    
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                }
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            withAnimation(.easeInOut(duration: 0.2)) {
                                tabHoverStates[tab] = true
                            }
                        }
                        .onEnded { _ in
                            withAnimation(.easeInOut(duration: 0.2)) {
                                tabHoverStates[tab] = false
                            }
                        }
                )
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background {
            ZStack {
                if settings.useLiquidGlass {
                    Capsule()
                        .liquidGlassThinEffect(true)
                        .overlay {
                            Capsule()
                                .strokeBorder(
                                    LinearGradient(
                                        colors: [
                                            Color.white.opacity(0.4),
                                            Color.white.opacity(0.1)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1.5
                                )
                        }
                        .shadow(color: Color.black.opacity(0.15), radius: 25, x: 0, y: 15)
                        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                } else {
                    Capsule()
                        .fill(.ultraThinMaterial)
                        .overlay {
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color.white.opacity(0.2),
                                            Color.white.opacity(0.05)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        }
                        .overlay {
                            Capsule()
                                .strokeBorder(
                                    LinearGradient(
                                        colors: [
                                            Color.white.opacity(0.4),
                                            Color.white.opacity(0.1)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1.5
                                )
                        }
                        .shadow(color: Color.black.opacity(0.15), radius: 25, x: 0, y: 15)
                        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                }
            }
        }
        .padding(.horizontal, 80)
        .padding(.bottom, 12)
    }
}

struct TabButton: View {
    let tab: Tab
    let isSelected: Bool
    let isHovered: Bool
    let namespace: Namespace.ID
    let action: () -> Void
    
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                scale = 0.85
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    scale = 1.0
                }
            }
            
            action()
        }) {
            ZStack {
                if isSelected {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.blue.opacity(0.3),
                                    Color.blue.opacity(0.15)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 44, height: 44)
                        .matchedGeometryEffect(id: "TAB", in: namespace)
                        .overlay {
                            Circle()
                                .strokeBorder(
                                    Color.blue.opacity(0.4),
                                    lineWidth: 1
                                )
                        }
                }
                
                Image(systemName: tab.rawValue)
                    .font(.system(size: 20, weight: isSelected ? .semibold : .medium))
                    .foregroundStyle(
                        LinearGradient(
                            colors: isSelected ? [Color.blue, Color.blue.opacity(0.8)] : [Color.secondary, Color.secondary.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 44, height: 44)
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                    .scaleEffect(scale)
            }
            .contentShape(Circle())
        }
        .buttonStyle(.plain)
    }
}
