//
//  PrivacyPolicyView.swift
//  FindMyPark
//
//  Created by Gary Clemente on 12/2/25.
//

import SwiftUI

struct PrivacyPolicy: View {
    var body: some View {
        SettingsDetailView(title: "Privacy Policy", systemIcon: "lock.doc.fill", iconColor: .purple) {
            NavigationLink("View Privacy Policy") {
                WebPageView(urlString: "https://yourwebsite.com/privacy")
            }
        }
    }
}
