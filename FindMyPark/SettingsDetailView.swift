//
//  SettingsDetailView.swift
//  FindMyPark
//
//  Created by Gary Clemente on 12/2/25.
//

import SwiftUI

struct SettingsDetailView<Content: View>: View {
    var title: String
    var systemIcon: String
    var iconColor: Color = .blue
    var content: () -> Content
    
    var body: some View {
        List {
            Section {
                content()
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
