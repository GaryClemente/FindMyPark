import SwiftUI

struct ContentView: View {
    @State private var searchTerm = ""
    @AppStorage("isDarkMode") private var darkModeEnabled = false   // ✅ FIXED — must be here

    var body: some View {

        TabView {

            NavigationStack {
                WelcomeView()
            }
            .tabItem {
                Label("Account", systemImage: "house")
            }

            NavigationStack {
                MapScreen()
            }
            .tabItem {
                Label("Map", systemImage: "map")
            }

            NavigationStack {
                SettingView()
            }
            .tabItem {
                Label("Settings", systemImage: "gearshape")
            }
            
            
        }
        .preferredColorScheme(darkModeEnabled ? .dark : .light)   // ✅ FIXED — applies theme globally
    }
}

#Preview {
    ContentView()
}
