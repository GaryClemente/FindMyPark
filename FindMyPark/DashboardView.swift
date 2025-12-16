//
//  DashboardView.swift
//  FindMyPark
//
//  Created by Gary Clemente on 12/5/25.
//

import SwiftUI

struct DashboardView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                Text("🎉 You’re Logged In!")
                    .font(.largeTitle)
                    .bold()

                Text("Welcome to your dashboard.")
                    .foregroundColor(.gray)

                Spacer()
            }
            .padding()
            .navigationTitle("Dashboard")
        }
    }
}
