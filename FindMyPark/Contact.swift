//
//  ContactView.swift
//  FindMyPark
//
//  Created by Gary Clemente on 12/2/25.
//

import SwiftUI
import MessageUI

struct ContactView: View {
    @State private var showMailer = false
    
    var body: some View {
        SettingsDetailView(title: "Contact", systemIcon: "envelope.fill", iconColor: .green) {
            Button {
                showMailer = true
            } label: {
                HStack {
                    Image(systemName: "envelope.fill").foregroundColor(.green)
                    Text("Email Support")
                }
            }
        }
        .sheet(isPresented: $showMailer) {
            MailView(
                subject: "Support Request",
                body: "Hello, I need assistance with...",
                to: "support@yourapp.com"
            )
        }
    }
}
