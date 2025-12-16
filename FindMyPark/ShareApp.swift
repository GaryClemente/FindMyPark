//
//  ShareAppView.swift
//  FindMyPark
//
//  Created by Gary Clemente on 12/2/25.
//

import SwiftUI

struct ShareApp: View {
    var body: some View {
        SettingsDetailView(title: "Share App", systemIcon: "square.and.arrow.up", iconColor: .blue) {
            Button(action: shareApp) {
                HStack {
                    Image(systemName: "square.and.arrow.up").foregroundColor(.blue)
                    Text("Share this app")
                }
            }
        }
    }

    private func shareApp() {
        guard let url = URL(string: "https://yourappurl.com") else { return }
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)

        UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?
            .rootViewController?
            .present(activityVC, animated: true)
    }
}
