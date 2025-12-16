//
//  CookiesPolicyView.swift
//  FindMyPark
//
//  Created by Gary Clemente on 12/2/25.
//

import SwiftUI

struct CookiesPolicy: View {
    var body: some View {
        SettingsDetailView(title: "Cookies Policy", systemIcon: "doc", iconColor: .brown) {
            NavigationLink("View Cookies Policy") {
                WebPageView(urlString: "https://yourwebsite.com/cookies")
            }
        }
    }
}
