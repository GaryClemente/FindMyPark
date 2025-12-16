//
//  TermsView.swift
//  FindMyPark
//
//  Created by Gary Clemente on 12/2/25.
//

import SwiftUI

struct Terms: View {
    var body: some View {
        SettingsDetailView(title: "Terms & Conditions", systemIcon: "doc.text.fill", iconColor: .orange) {
            NavigationLink("View Terms") {
                WebPageView(urlString: "https://yourwebsite.com/terms")
            }
        }
    }
}
