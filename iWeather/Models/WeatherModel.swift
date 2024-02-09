//
//  WeatherModel.swift
//  iWeather
//
//  Created by Юрий Степанчук on 09.02.2024.
//

import Foundation

struct WeatherModel: Codable {
    let geoObject: GeoObject
    let fact: Fact
    let forecasts: [Forecast]

    enum CodingKeys: String, CodingKey {
        case geoObject = "geo_object"
        case fact
        case forecasts
    }
}

struct Fact: Codable {
    let temp: Int?
    let feelsLike: Int?
    let icon: String?
    let condition: String?
    let windSpeed: Double?
    let windDir: String?
    let pressureMm: Int?
    let humidity: Int?
    let daytime: String?
    let season: String?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case icon
        case condition
        case windSpeed = "wind_speed"
        case windDir = "wind_dir"
        case pressureMm = "pressure_mm"
        case humidity
        case daytime
        case season
    }
}

struct Forecast: Codable {
    let date: String?
    let parts: Parts
    let hours: [Hour]
}

struct Hour: Codable {
    let hour: String?
    let temp: Int?
    let icon: String?
}

struct Parts: Codable {
    let nightShort: Fact
    let dayShort: Fact

    enum CodingKeys: String, CodingKey  {
        case nightShort = "night_short"
        case dayShort = "day_short"
    }
}

struct GeoObject: Codable {
    let locality: Country
}

struct Country: Codable {
    let name: String
}
