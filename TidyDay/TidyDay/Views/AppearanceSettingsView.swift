//
//  AppearanceSettingsView.swift
//  TidyDay
//
//  Created by John Rediker on 10/28/25.
//

import SwiftUI

struct AppearanceSettingsView: View {
    @Environment(\.dismiss) var dismiss
    @State var settings: AppSettings
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    if settings.isLiquidGlassAvailable {
                        Toggle(isOn: $settings.useLiquidGlass) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Liquid Glass")
                                    .font(.system(size: 17, weight: .regular))
                                
                                Text("Enhanced translucent materials with depth")
                                    .font(.system(size: 13, weight: .regular))
                                    .foregroundColor(.secondary)
                            }
                        }
                        .tint(.blue)
                    } else {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Liquid Glass")
                                    .font(.system(size: 17, weight: .regular))
                                    .foregroundColor(.secondary)
                                
                                Text("Requires iOS 18.2 or later")
                                    .font(.system(size: 13, weight: .regular))
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "lock.fill")
                                .foregroundColor(.secondary)
                        }
                    }
                } header: {
                    Text("Materials")
                } footer: {
                    if settings.isLiquidGlassAvailable {
                        Text("Liquid Glass provides enhanced depth and translucency for backgrounds, panels, and overlays. Best experienced on devices running iOS 18.2 or later.")
                    } else {
                        Text("Liquid Glass is available on iOS 18.2+. Update your device to access this feature.")
                    }
                }
            }
            .navigationTitle("Appearance")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
