//
//  PresetCity.swift
//  iWeather
//
//  Created by Юрий Степанчук on 12.02.2024.
//

enum PresetCity: CaseIterable {
    case moscow
    case krasnodar
    case novosibirsk
    case yekaterinburg
    case bratsk
    case kazan
    case tula
    case omsk
    case samara
    case rostovOnDon

    var coordinates: (latitude: String, longitude: String) {
        switch self {
        case .moscow: return ("55.7558", "37.6176")
        case .krasnodar: return ("45.023877", "38.970157")
        case .novosibirsk: return ("55.0084", "82.9357")
        case .yekaterinburg: return ("56.8389", "60.6057")
        case .bratsk: return ("56.151382", "101.634152")
        case .kazan: return ("55.8304", "49.0661")
        case .tula: return ("54.193033", "37.617752")
        case .omsk: return ("54.9885", "73.3242")
        case .samara: return ("53.1952", "50.1069")
        case .rostovOnDon: return ("47.2357", "39.7015")
        }
    }
}
