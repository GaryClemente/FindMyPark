import SwiftUI
import MapKit

struct MapScreen: View {

    @StateObject private var locationManager = LocationManager()

    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var searchText = ""

    @State private var searchResults: [MKMapItem] = []
    @State private var selectedItem: IdentifiableMapItem?

    @State private var walkingRoute: MKRoute?
    @State private var drivingRoute: MKRoute?

    @State private var walkingInfo = "--"
    @State private var drivingInfo = "--"

    @State private var favorites: [FavoritePark] = []

    @State private var droppedPin: CLLocationCoordinate2D?

    @State private var showPlaygrounds = true
    @State private var showDogParks = true

    var body: some View {
        ZStack {

            // MARK: MAP
            Map(position: $cameraPosition) {

                UserAnnotation()

                // 📌 Dropped Pin
                if let droppedPin {
                    Annotation("Dropped Pin", coordinate: droppedPin) {
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundStyle(.purple)
                            .font(.title)
                    }
                }

                // 📍 Search Results
                ForEach(filteredResults(), id: \.self) { item in
                    Annotation(item.name ?? "Park",
                               coordinate: item.placemark.coordinate) {
                        Button {
                            selectedItem = IdentifiableMapItem(item: item)
                            calculateRoutes(to: item)
                        } label: {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundStyle(.red)
                                .font(.title)
                        }
                    }
                }

                // 🧭 Routes
                if let walkingRoute {
                    MapPolyline(walkingRoute.polyline)
                        .stroke(.blue, lineWidth: 4)
                }

                if let drivingRoute {
                    MapPolyline(drivingRoute.polyline)
                        .stroke(.green, lineWidth: 4)
                }
            }
            .ignoresSafeArea()
            .onLongPressGesture {
                droppedPin = locationManager.userLocation?.coordinate
            }

            // 🧭 Recenter Button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        recenter()
                    } label: {
                        Image(systemName: "location.fill")
                            .padding()
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                    .padding()
                }
            }

            // 🔍 Search + Filters
            VStack(spacing: 8) {

                TextField("Search parks", text: $searchText)
                    .padding(12)
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .padding(.top, 60)
                    .onSubmit { searchParks() }

                HStack {
                    Toggle("Playgrounds", isOn: $showPlaygrounds)
                    Toggle("Dog Parks", isOn: $showDogParks)
                }
                .padding(8)
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                .padding(.horizontal)

                // 🧠 Smart Recommendations
                if let user = locationManager.userLocation {
                    VStack(alignment: .leading) {
                        Text("Recommended")
                            .font(.headline)
                        ForEach(recommended(from: user), id: \.self) {
                            Text($0.name ?? "")
                                .font(.subheadline)
                        }
                    }
                    .padding()
                    .background(.thinMaterial)
                    .cornerRadius(12)
                    .padding(.horizontal)
                }

                Spacer()
            }
        }
        .sheet(item: $selectedItem) { wrapper in
            infoSheet(for: wrapper.item)
        }
        .onAppear { loadFavorites() }
    }

    // MARK: SEARCH
    func searchParks() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText

        if let user = locationManager.userLocation {
            request.region = MKCoordinateRegion(
                center: user.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
            )
        }

        MKLocalSearch(request: request).start { response, _ in
            DispatchQueue.main.async {
                searchResults = response?.mapItems ?? []
            }
        }
    }

    // MARK: FILTERS
    func filteredResults() -> [MKMapItem] {
        searchResults.filter {
            let name = ($0.name ?? "").lowercased()
            if name.contains("dog") && !showDogParks { return false }
            if name.contains("playground") && !showPlaygrounds { return false }
            return true
        }
    }

    // MARK: ROUTES + ETA
    func calculateRoutes(to item: MKMapItem) {
        guard let user = locationManager.userLocation else { return }
        let source = MKMapItem(placemark: MKPlacemark(coordinate: user.coordinate))

        let req = MKDirections.Request()
        req.source = source
        req.destination = item

        req.transportType = .walking
        MKDirections(request: req).calculate { r, _ in
            walkingRoute = r?.routes.first
            if let route = r?.routes.first {
                walkingInfo = "\(Int(route.expectedTravelTime/60)) min • \(String(format: "%.2f", route.distance/1609.34)) mi"
            }
        }

        req.transportType = .automobile
        MKDirections(request: req).calculate { r, _ in
            drivingRoute = r?.routes.first
            if let route = r?.routes.first {
                drivingInfo = "\(Int(route.expectedTravelTime/60)) min • \(String(format: "%.2f", route.distance/1609.34)) mi"
            }
        }
    }

    // MARK: FAVORITES
    func saveFavorite(_ item: MKMapItem) {
        let fav = FavoritePark(
            name: item.name ?? "Park",
            latitude: item.placemark.coordinate.latitude,
            longitude: item.placemark.coordinate.longitude
        )
        favorites.append(fav)
        UserDefaults.standard.set(try? JSONEncoder().encode(favorites),
                                  forKey: "favorites")
    }

    func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: "favorites"),
           let decoded = try? JSONDecoder().decode([FavoritePark].self, from: data) {
            favorites = decoded
        }
    }

    // MARK: HELPERS
    func recenter() {
        guard let user = locationManager.userLocation else { return }
        cameraPosition = .region(
            MKCoordinateRegion(
                center: user.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
        )
    }

    func recommended(from user: CLLocation) -> [MKMapItem] {
        searchResults
            .sorted {
                user.distance(from: CLLocation(latitude: $0.placemark.coordinate.latitude,
                                               longitude: $0.placemark.coordinate.longitude))
                <
                user.distance(from: CLLocation(latitude: $1.placemark.coordinate.latitude,
                                               longitude: $1.placemark.coordinate.longitude))
            }
            .prefix(3)
            .map { $0 }
    }

    func infoSheet(for item: MKMapItem) -> some View {
        VStack(spacing: 16) {
            Text(item.name ?? "Park").font(.title2).bold()
            HStack {
                Label(walkingInfo, systemImage: "figure.walk")
                Label(drivingInfo, systemImage: "car")
            }
            Button("Save to Favorites") {
                saveFavorite(item)
            }
            .buttonStyle(.borderedProminent)
            Spacer()
        }
        .padding()
        .presentationDetents([.medium])
    }
}

