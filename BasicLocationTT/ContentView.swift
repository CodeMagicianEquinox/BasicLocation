//
//  ContentView.swift
//  BasicLocationTT
//
//  Created by Timothy Terrance on 5/11/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var locationViewModel: LocationViewModel = LocationViewModel()
    @StateObject private var weatherViewModel: WeatherViewModel = WeatherViewModel()
    
    var body: some View {
        VStack {
            switch locationViewModel.viewState {
            case .ready:
                LocationReadyView(
                    latText: locationViewModel.latitude,
                    longText: locationViewModel.longitude,
                    weather: weatherViewModel.weather,
                    isLoading: weatherViewModel.isLoading,
                    errorMessage: weatherViewModel.errorMessage,
                    lastUpdated: weatherViewModel.lastUpdated,
                    onRefreshLocation: locationViewModel.refreshButton,
                    onRefreshWeather: weatherViewModel.refresh
                )
            case .loading:
                ProgressView("Finding your location...")
            case .needsPermission, .denied, .failed:
                PermissionView(
                    message: locationViewModel.errorMessage.isEmpty
                        ? "Location access is needed to show current weather."
                        : locationViewModel.errorMessage,
                    onEnable: locationViewModel.enableLocation
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            locationViewModel.enableLocation()
        }
        .onDisappear {
            locationViewModel.stopLocationUpdates()
        }
        .onReceive(locationViewModel.$lastCoordinate) { coordinate in
            weatherViewModel.updateWeather(for: coordinate)
        }
    }
}

#Preview {
    ContentView()
}
