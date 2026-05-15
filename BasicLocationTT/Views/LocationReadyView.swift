//
//  LocationReadyView.swift
//  BasicLocationTT
//
//  Created by Timothy Terrance on 5/11/26.
//

import SwiftUI

struct LocationReadyView: View {
    
    let latText: String
    let longText: String
    let weather: WeatherModel?
    let isLoading: Bool
    let errorMessage: String?
    let lastUpdated: Date?
    let onRefreshLocation: () -> Void
    let onRefreshWeather: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            VStack {
                Text("Using current location")
                    .font(.headline)
                Text("Longitude: " + longText)
                Text("Latitude: " + latText)
                    .foregroundStyle(.secondary)
            }
                
            if isLoading {
                ProgressView("Loading weather...")
            } else if let weather {
                VStack(spacing: 12) {
                    Text("\(weather.temperature, specifier: "%.0f")\(weather.temperatureUnit)")
                        .font(.system(size: 48, weight: .semibold))
                    Text(weather.condition)
                        .font(.title3)
                    Text("Wind: \(weather.windSpeed, specifier: "%.1f") \(weather.windSpeedUnit)")
                    if let lastUpdated {
                        Text("Last updated: \(lastUpdated.formatted(date: .omitted, time: .shortened))")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
            } else if let errorMessage {
                VStack(spacing: 8) {
                    Text(errorMessage)
                        .multilineTextAlignment(.center)
                    Button("Retry") {
                        self.onRefreshWeather()
                    }
                    .buttonStyle(.borderedProminent)
                }
            } else {
                Text("Waiting for weather...")
                    .foregroundStyle(.secondary)
            }

            HStack {
                Button("Refresh Location") {
                    self.onRefreshLocation()
                }
                .buttonStyle(.bordered)
                
                Button("Refresh Weather") {
                    self.onRefreshWeather()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
    }
}
