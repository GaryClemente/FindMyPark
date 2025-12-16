//
//  FindMyParkApp.swift
//  FindMyPark
//
//  Created by Gary Clemente on 11/4/25.
//

import SwiftUI

@main
struct FindMyParkApp: App {
    @AppStorage("isDarkMode") private var darkModeEnabled = false

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(darkModeEnabled ? .dark : .light)


        }
    }
}
