//
//  LocationService.swift
//  BasicLocationTT
//
//  Created by Timothy Terrance on 5/11/26.
//

import Foundation
import CoreLocation
import Combine

@MainActor
class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    // The below object handles the CoreLocation API
    private let manager: CLLocationManager = CLLocationManager()
    
    @Published var location: CLLocationCoordinate2D?
    @Published var isLoading: Bool = false
    @Published var authStatus: CLAuthorizationStatus = .notDetermined
    @Published var errorMessage: String?
    
    override init() {

        super.init()
        
        // Configure manager
        manager.delegate = self
        
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        authStatus = manager.authorizationStatus
    }
    
    // Optionally expose helpers to start/stop updates
    func startUpdatingLocation() {
        errorMessage = nil
        authStatus = manager.authorizationStatus

        switch authStatus {
        case .notDetermined:
            isLoading = true
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            isLoading = true
            manager.startUpdatingLocation()
        case .denied, .restricted:
            isLoading = false
            errorMessage = "Location access is turned off. Enable it in Settings to use current weather."
        @unknown default:
            isLoading = false
            errorMessage = "Location permission is unavailable right now."
        }
    }
    
    func stopUpdatingLocation() {
        manager.stopUpdatingLocation()
        isLoading = false
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        authStatus = manager.authorizationStatus
        
        if authStatus == .authorizedWhenInUse || authStatus == .authorizedAlways{
            isLoading = true
            manager.startUpdatingLocation()
        } else {
            isLoading = false
            if authStatus == .denied || authStatus == .restricted {
                errorMessage = "Location access is turned off. Enable it in Settings to use current weather."
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let lastLocation = locations.last {
            location = lastLocation.coordinate
        }
        
        errorMessage = nil
        isLoading = false
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        
        isLoading = false
        errorMessage = "Could not read your location. Please try again."
    }

}
