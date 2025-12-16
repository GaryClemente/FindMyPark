import SwiftUI
import MapKit

struct MapScreen: View {

    @State private var searchResults: [MKMapItem] = []
    @State private var nearestPark: MKMapItem?

    @StateObject private var locationManager = LocationManager()

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.3349, longitude: -122.0090),
        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    )

    @State private var searchText = ""
    @State private var mapType: MKMapType = .standard
    @State private var showingDirections = false

    let locations: [Place] = sampleLocations

    // MARK: - FORMAT DISTANCE
    func formatDistance(to item: MKMapItem) -> String {
        guard let user = locationManager.userLocation else { return "" }

        let userLocation = CLLocation(latitude: user.coordinate.latitude,
                                      longitude: user.coordinate.longitude)

        let parkLocation = CLLocation(latitude: item.placemark.coordinate.latitude,
                                      longitude: item.placemark.coordinate.longitude)

        let meters = userLocation.distance(from: parkLocation)
        let miles = meters / 1609.34

        return String(format: "%.2f miles away", miles)
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {

                // MARK: - MAIN MAP
                Map(
                    coordinateRegion: $region,
                    interactionModes: .all,
                    showsUserLocation: true,
                    annotationItems: nearestPark == nil
                        ? locations
                        : [Place(
                            name: nearestPark?.name ?? "Nearest Park",
                            coordinate: nearestPark!.placemark.coordinate
                        )]
                ) { place in
                    MapAnnotation(coordinate: place.coordinate) {
                        VStack(spacing: 4) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.title)
                                .foregroundColor(.red)

                            Text(place.name)
                                .font(.caption)
                                .padding(4)
                                .background(.thinMaterial)
                                .cornerRadius(6)
                        }
                    }
                }
                .mapStyle(mapType == .standard ? .standard : .hybrid)
                .ignoresSafeArea()

                // MARK: - SEARCH BAR
                VStack {
                    TextField("Search for parks…", text: $searchText)
                        .padding(12)
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                        .shadow(radius: 4)
                        .padding(.horizontal)
                        .padding(.top, 60)
                        .onChange(of: searchText) { newValue in
                            searchForParks(query: newValue)
                        }

                    // DISTANCE LABEL (only when a park is selected)
                    if let park = nearestPark {
                        Text("\(park.name ?? "Park") • \(formatDistance(to: park))")
                            .font(.headline)
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)
                            .padding(.top, 10)
                    }

                    Spacer()
                }

                // MARK: - FLOATING BUTTONS (RIGHT SIDE)
                floatingButtons
                    .padding(.trailing)
                    .padding(.bottom, 40)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            }
            .navigationBarHidden(true)
        }
    }

    // MARK: - FLOATING BUTTONS UI
    var floatingButtons: some View {
        VStack(spacing: 12) {

            // RECENTER
            Button {
                if let loc = locationManager.userLocation {
                    region.center = loc.coordinate
                }
            } label: {
                circleButton("location.fill")
            }

            // ZOOM IN
            Button {
                region.span.latitudeDelta /= 1.5
                region.span.longitudeDelta /= 1.5
            } label: {
                circleButton("plus")
            }

            // ZOOM OUT
            Button {
                region.span.latitudeDelta *= 1.5
                region.span.longitudeDelta *= 1.5
            } label: {
                circleButton("minus")
            }

            // MAP STYLE
            Button {
                mapType = mapType == .standard ? .hybrid : .standard
            } label: {
                circleButton("square.3.layers.3d")
            }
        }
    }

    // MARK: - SEARCH FUNCTION
    func searchForParks(query: String) {
        guard !query.isEmpty else { return }

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "park \(query)"
        request.region = region

        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else { return }

            searchResults = response.mapItems

            if let closest = response.mapItems.first {
                nearestPark = closest

                // Auto zoom
                region.center = closest.placemark.coordinate
                region.span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            }
        }
    }
}


// MARK: - BUTTON STYLE HELPER
func circleButton(_ systemName: String) -> some View {
    Image(systemName: systemName)
        .font(.title2)
        .padding()
        .background(.thinMaterial)
        .clipShape(Circle())
}


#Preview {
    MapScreen()
}

