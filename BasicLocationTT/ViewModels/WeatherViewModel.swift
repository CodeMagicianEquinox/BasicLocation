//
//  WeatherViewModel.swift
//  BasicLocationTT
//
//  Created by Timothy Terrance on 5/15/26.
//

import CoreLocation
import Combine
import Foundation

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var weather: WeatherModel?
    @Published var errorMessage: String?
    @Published var lastUpdated: Date?

    private let weatherService: WeatherService
    private var currentCoordinate: CLLocationCoordinate2D?

    init(weatherService: WeatherService = WeatherService()) {
        self.weatherService = weatherService
    }

    func updateWeather(for coordinate: CLLocationCoordinate2D?) {
        guard let coordinate else {
            return
        }

        if let currentCoordinate,
           abs(currentCoordinate.latitude - coordinate.latitude) < 0.0001,
           abs(currentCoordinate.longitude - coordinate.longitude) < 0.0001,
           weather != nil {
            return
        }

        currentCoordinate = coordinate
        fetchWeather(for: coordinate)
    }

    func refresh() {
        guard let currentCoordinate else {
            errorMessage = "Waiting for your location before refreshing weather."
            return
        }

        fetchWeather(for: currentCoordinate)
    }

    private func fetchWeather(for coordinate: CLLocationCoordinate2D) {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let newWeather = try await weatherService.fetchWeather(for: coordinate)
                weather = newWeather
                lastUpdated = newWeather.fetchedAt
                isLoading = false
            } catch {
                errorMessage = error.localizedDescription
                isLoading = false
            }
        }
    }
}
