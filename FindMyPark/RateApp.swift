//
//  RateAppView.swift
//  FindMyPark
//
//  Created by Gary Clemente on 12/2/25.
//

import SwiftUI
import StoreKit

struct RateAppView: View {
    @Environment(\.requestReview) private var requestReview
    
    var body: some View {
        SettingsDetailView(title: "Rate App", systemIcon: "star.fill", iconColor: .yellow) {
            Button {
                requestReview()
            } label: {
                HStack {
                    Image(systemName: "hand.thumbsup.fill").foregroundColor(.yellow)
                    Text("Tap to rate this app")
                }
            }
        }
    }
}
