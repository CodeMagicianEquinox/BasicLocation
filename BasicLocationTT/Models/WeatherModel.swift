//
//  WeatherModel.swift
//  BasicLocationTT
//
//  Created by Timothy Terrance on 5/15/26.
//

import Foundation

nonisolated struct WeatherModel {
    let temperature: Double
    let temperatureUnit: String
    let condition: String
    let windSpeed: Double
    let windSpeedUnit: String
    let fetchedAt: Date
}
