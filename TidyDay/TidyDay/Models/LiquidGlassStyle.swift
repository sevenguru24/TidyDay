//
//  LiquidGlassStyle.swift
//  TidyDay
//
//  Created by John Rediker on 10/28/25.
//

import SwiftUI

// Custom liquid glass style that mimics the iOS 18.2+ liquidGlass material
// When iOS 18.2 is released, this can be replaced with the native .liquidGlass
struct LiquidGlassBackground: View {
    var body: some View {
        ZStack {
            // Base ultra-thin material for translucency
            Color.clear
                .background(.ultraThinMaterial)
            
            // Brighter gradient overlay for glassy appearance
            LinearGradient(
                colors: [
                    Color.white.opacity(0.25),
                    Color.white.opacity(0.08)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}

extension View {
    @ViewBuilder
    func liquidGlassEffect(_ enabled: Bool) -> some View {
        if enabled {
            self.background(LiquidGlassBackground())
        } else {
            self.background(.regularMaterial)
        }
    }
    
    @ViewBuilder
    func liquidGlassThinEffect(_ enabled: Bool) -> some View {
        if enabled {
            self.background(LiquidGlassBackground())
        } else {
            self.background(.ultraThinMaterial)
        }
    }
}
