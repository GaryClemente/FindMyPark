//
//  RateAppView.swift
//  FindMyPark
//
//  Created by Gary Clemente on 12/2/25.
//
//
//import SwiftUI
//import StoreKit
//
//struct RateApp: View {
//    @Environment(\.requestReview) private var requestReview
//    
//    var body: some View {
//        SettingsDetailView(title: "Rate App", systemIcon: "star.fill", iconColor: .yellow) {
//            Button {
//                requestReview()
//            } label: {
//                HStack {
//                    Image(systemName: "hand.thumbsup.fill").foregroundColor(.yellow)
//                    Text("Tap to rate this app")
//                }
//            }
//        }
//    }
//}
//
//  RateAppView.swift
//  FindMyPark
//
//  Created by Gary Clemente on 12/2/25.
//
import SwiftUI
import StoreKit

struct RateApp: View {
    
    @Environment(\.requestReview) private var requestReview
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "star.fill")
                .font(.system(size: 60))
                .foregroundColor(.yellow)

            Text("Enjoying FindMyPark?")
                .font(.title2)
                .bold()

            Text("Tap below to rate it on the App Store.")
                .foregroundColor(.gray)

            Button {
                requestReview()   // ✅ This triggers Apple's popup
            } label: {
                Text("Rate This App")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    RateApp()
}
