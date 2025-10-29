//
//  AppSettings.swift
//  TidyDay
//
//  Created by John Rediker on 10/28/25.
//

import Foundation
import SwiftUI

@Observable
class AppSettings {
    var useLiquidGlass: Bool {
        didSet {
            UserDefaults.standard.set(useLiquidGlass, forKey: "useLiquidGlass")
        }
    }
    
    init() {
        self.useLiquidGlass = UserDefaults.standard.bool(forKey: "useLiquidGlass")
    }
    
    var isLiquidGlassAvailable: Bool {
        if #available(iOS 18.2, *) {
            return true
        }
        return false
    }
}
