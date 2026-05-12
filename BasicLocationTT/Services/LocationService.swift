//
//  LocationService.swift
//  BasicLocationTT
//
//  Created by Timothy Terrance on 5/11/26.
//

import Foundation
import CoreLocation
import Combine

class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {

    // The below object handles the CoreLocation API
    private let manager: CLLocationManager = CLLocationManager()

    @Published var location: CLLocationCoordinate2D?
    @Published var isLoading: Bool = false
    @Published var authStatus: CLAuthorizationStatus = .notDetermined

    override init() {
        // Provide a sensible default coordinate (0,0) until we receive a real location
        self.location = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        super.init()
        // Configure manager
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        // Request authorization up front; callers can control timing if needed
        manager.requestWhenInUseAuthorization()
    }

    // Optionally expose helpers to start/stop updates
    func startUpdatingLocation() {
        isLoading = true
        manager.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        manager.stopUpdatingLocation()
        isLoading = false
    }

    // MARK: - CLLocationManagerDelegate

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authStatus = manager.authorizationStatus
        switch authStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            // Optionally start updating when authorized
            manager.startUpdatingLocation()
        case .denied, .restricted, .notDetermined:
            break
        @unknown default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latest = locations.last else { return }
        location = latest.coordinate
        isLoading = false
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Stop loading on failure; you may want to surface the error via another @Published property
        isLoading = false
        // print("Location error: \(error.localizedDescription)")
    }
}
