//
//  SettingsView.swift
//  Tripify
//
//  Created by Krishay Gahlaut on 14/06/25.
//
import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") var isDarkMode = false

    var body: some View {
        NavigationStack {
            Form {
                Toggle("Dark Mode", isOn: $isDarkMode)
            }
            .navigationTitle("Settings")
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}
