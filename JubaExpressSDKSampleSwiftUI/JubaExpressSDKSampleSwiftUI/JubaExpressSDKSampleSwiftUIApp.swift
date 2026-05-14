//
//  JubaExpressSDKSampleSwiftUIApp.swift
//  JubaExpressSDKSampleSwiftUI
//
//  Created by Muhammad kumail on 01/04/2026.
//

import SwiftUI
import IQKeyboardManagerSwift
import IQKeyboardToolbarManager

@main
struct JubaExpressSDKSampleSwiftUIApp: App {
    
    init() {
            IQKeyboardManager.shared.isEnabled = true
            IQKeyboardToolbarManager.shared.isEnabled = true
        }
    
    var body: some Scene {
        WindowGroup {
            ConfigurationView()
        }
    }
}
