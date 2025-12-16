import SwiftUI

struct SettingView: View {
    @State private var notificationEnabled = false
    @AppStorage("isDarkMode") private var darkModeEnabled = false

    var body: some View {
        NavigationView {
            List {

                // MARK: - Notification Toggle
                Section {
                    HStack(spacing: 14) {
                        Image(systemName: "bell.fill")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.tint)

                        Toggle("Notification", isOn: $notificationEnabled)
                    }
                    .padding(.vertical, 6)
                }

                // MARK: - Dark Mode Toggle
                Section {
                    HStack(spacing: 14) {
                        Image(systemName: "moon.fill")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.tint)

                        Toggle("Dark Mode", isOn: $darkModeEnabled)
                    }
                    .padding(.vertical, 6)
                }

                // MARK: - Other Settings Options
                Section {                    
                    NavigationLink(destination: RateApp()) {
                        SettingsRow(icon: "star.fill", title: "Rate App")
                    }

                    NavigationLink(destination: ShareAppView()) {
                        SettingsRow(icon: "square.and.arrow.up.fill", title: "Share App")
                    }

                    NavigationLink(destination: PrivacyPolicyView()) {
                        SettingsRow(icon: "lock.shield.fill", title: "Privacy Policy")
                    }

                    NavigationLink(destination: TermsView()) {
                        SettingsRow(icon: "doc.text.fill", title: "Terms and Conditions")
                    }

                    NavigationLink(destination: CookiesPolicyView()) {
                        SettingsRow(icon: "doc.plaintext.fill", title: "Cookies Policy")
                    }

                    NavigationLink(destination: ContactView()) {
                        SettingsRow(icon: "envelope.fill", title: "Contact")
                    }

                    NavigationLink(destination: FeedbackView()) {
                        SettingsRow(icon: "bubble.left.fill", title: "Feedback")
                    }
                }


            }
            .navigationTitle("Settings")
        }
    }
}


// MARK: - Reusable Row Component
struct SettingsRow: View {
    var icon: String
    var title: String
    var iconColor: Color = .gray

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(iconColor)

            Text(title)
                .foregroundColor(.primary)
        }
        .padding(.vertical, 4)
    }
}


// MARK: - Placeholder Views
struct RateAppView: View { var body: some View { Text("Rate App") } }
struct ShareAppView: View { var body: some View { Text("Share App") } }
struct PrivacyPolicyView: View { var body: some View { Text("Privacy Policy") } }
struct TermsView: View { var body: some View { Text("Terms and Conditions") } }
struct CookiesPolicyView: View { var body: some View { Text("Cookies Policy") } }
struct ContactView: View { var body: some View { Text("Contact") } }
struct FeedbackView: View { var body: some View { Text("Feedback") } }


#Preview {
    SettingView()
}

