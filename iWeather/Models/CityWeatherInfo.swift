//
//  CityWeatherInfo.swift
//  iWeather
//
//  Created by Юрий Степанчук on 09.02.2024.
//

import Foundation

struct CityWeatherInfo: Codable {
    let geoObject: GeoObject
    let fact: Fact
    var forecasts: [Forecast]

    enum CodingKeys: String, CodingKey {
        case geoObject = "geo_object"
        case fact
        case forecasts
    }

    var temperatureRange: String {
        guard let firstForecast = forecasts.first else { return "" }
        let temperatures = firstForecast.hours.map { $0.temperature }
        guard let minTemperature = temperatures.min(),
              let maxTemperature = temperatures.max()
        else { return "" }
        return "\(minTemperature)".addDegreeSymbol() + "/" + "\(maxTemperature)".addDegreeSymbol()
    }
}

struct Fact: Codable {
    let temp: Int?
    let icon: String?
    let condition: String?

    enum CodingKeys: String, CodingKey {
        case temp
        case icon
        case condition
    }
}

struct Forecast: Codable {
    let date: String?
    var hours: [HourWeatherInfo]
}

struct HourWeatherInfo: Codable {
    let hour: String
    let temperature: Int
    let iconName: String
    var iconImageData: Data?

    enum CodingKeys: String, CodingKey {
        case hour
        case temperature = "temp"
        case iconName = "icon"
    }
}

struct GeoObject: Codable {
    let locality: Country
}

struct Country: Codable {
    let name: String
}
