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
    
    private func requestLocation() {
        isLoading = true
        // Request a single location update
        manager.requestLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        authStatus = manager.authorizationStatus
        
        if authStatus == .authorizedWhenInUse || authStatus == .authorizedAlways{
            
            requestLocation()
        } else {
            isLoading = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let lastLocation = locations.last {
            location = lastLocation.coordinate
        }
        
        isLoading = false
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        
        isLoading = false
    }

}
