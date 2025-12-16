//
//  Place.swift
//  FindMyPark
//
//  Created by Gary Clemente on 11/21/25.
//

import MapKit

struct Place: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}


//Example incase

let sampleLocations = [
    Place(name: "Coffee Shop", coordinate: .init(latitude: 37.3349, longitude: -122.0090)),
    Place(name: "Book Store", coordinate: .init(latitude: 37.3317, longitude: -122.0307))
]
