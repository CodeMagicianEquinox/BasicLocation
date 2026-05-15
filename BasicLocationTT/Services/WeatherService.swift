//
//  WeatherService.swift
//  BasicLocationTT
//
//  Created by Timothy Terrance on 5/15/26.
//

import CoreLocation
import Foundation

nonisolated enum WeatherServiceError: LocalizedError {
    case invalidURL
    case badResponse
    case decodeFailed
    case networkFailed

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Could not build the weather request."
        case .badResponse:
            return "The weather server did not return a valid response."
        case .decodeFailed:
            return "Could not read the weather data."
        case .networkFailed:
            return "Could not connect to the weather service. Check your internet connection and try again."
        }
    }
}

nonisolated struct WeatherService {
    func fetchWeather(for coordinate: CLLocationCoordinate2D) async throws -> WeatherModel {
        guard let url = makeURL(for: coordinate) else {
            throw WeatherServiceError.invalidURL
        }

        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await URLSession.shared.data(from: url)
        } catch {
            throw WeatherServiceError.networkFailed
        }

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw WeatherServiceError.badResponse
        }

        do {
            let decoded = try JSONDecoder().decode(OpenMeteoResponse.self, from: data)
            return WeatherModel(
                temperature: decoded.currentWeather.temperature,
                temperatureUnit: decoded.currentWeatherUnits.temperature,
                condition: Self.summary(for: decoded.currentWeather.weatherCode),
                windSpeed: decoded.currentWeather.windSpeed,
                windSpeedUnit: decoded.currentWeatherUnits.windSpeed,
                fetchedAt: Date()
            )
        } catch {
            throw WeatherServiceError.decodeFailed
        }
    }

    private func makeURL(for coordinate: CLLocationCoordinate2D) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.open-meteo.com"
        components.path = "/v1/forecast"
        components.queryItems = [
            URLQueryItem(name: "latitude", value: String(coordinate.latitude)),
            URLQueryItem(name: "longitude", value: String(coordinate.longitude)),
            URLQueryItem(name: "current_weather", value: "true"),
            URLQueryItem(name: "temperature_unit", value: "fahrenheit"),
            URLQueryItem(name: "windspeed_unit", value: "mph"),
            URLQueryItem(name: "timezone", value: "auto")
        ]
        return components.url
    }

    private static func summary(for code: Int) -> String {
        switch code {
        case 0:
            return "Clear"
        case 1, 2:
            return "Partly cloudy"
        case 3:
            return "Overcast"
        case 45, 48:
            return "Fog"
        case 51, 53, 55, 56, 57:
            return "Drizzle"
        case 61, 63, 65, 66, 67, 80, 81, 82:
            return "Rain"
        case 71, 73, 75, 77, 85, 86:
            return "Snow"
        case 95, 96, 99:
            return "Thunderstorm"
        default:
            return "Weather code \(code)"
        }
    }
}

nonisolated private struct OpenMeteoResponse: Decodable {
    let currentWeather: OpenMeteoCurrentWeather
    let currentWeatherUnits: OpenMeteoCurrentWeatherUnits

    enum CodingKeys: String, CodingKey {
        case currentWeather = "current_weather"
        case currentWeatherUnits = "current_weather_units"
    }
}

nonisolated private struct OpenMeteoCurrentWeather: Decodable {
    let temperature: Double
    let windSpeed: Double
    let weatherCode: Int

    enum CodingKeys: String, CodingKey {
        case temperature
        case windSpeed = "windspeed"
        case weatherCode = "weathercode"
    }
}

nonisolated private struct OpenMeteoCurrentWeatherUnits: Decodable {
    let temperature: String
    let windSpeed: String

    enum CodingKeys: String, CodingKey {
        case temperature
        case windSpeed = "windspeed"
    }
}
