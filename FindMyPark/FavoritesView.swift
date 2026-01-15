import SwiftUI
import MapKit

struct FavoritesView: View {

    @State private var favorites: [FavoritePark] = []

    var body: some View {
        NavigationStack {
            List(favorites) { park in
                HStack {
                    Text(park.name)
                    Spacer()
                    Button {
                        openDirections(park)
                    } label: {
                        Image(systemName: "arrow.triangle.turn.up.right.diamond")
                    }
                }
            }
            .navigationTitle("Favorites")
        }
        .onAppear { loadFavorites() }
    }

    func openDirections(_ park: FavoritePark) {
        let item = MKMapItem(
            placemark: MKPlacemark(
                coordinate: CLLocationCoordinate2D(
                    latitude: park.latitude,
                    longitude: park.longitude
                )
            )
        )
        item.name = park.name
        item.openInMaps()
    }

    func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: "favorites"),
           let decoded = try? JSONDecoder().decode([FavoritePark].self, from: data) {
            favorites = decoded
        }
    }
}
