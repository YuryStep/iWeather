//
//  String+Extensions.swift
//  iWeather
//
//  Created by Юрий Степанчук on 10.02.2024.
//

import Foundation

extension String {
    func addDegreeSymbol() -> String {
        return self + "°C"
    }
}

extension String {
    func transformedTo12HourFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        let currentHourString = dateFormatter.string(from: Date())

        guard let currentHour = Int(currentHourString),
              let inputHourValue = Int(self),
              inputHourValue >= 0 && inputHourValue <= 23
        else {
            return "Invalid input"
        }

        if currentHour == inputHourValue {
            return "Now"
        } else {
            let formattedHour: String

            if currentHour >= inputHourValue && currentHour < inputHourValue + 1 {
                formattedHour = dateFormatter.string(from: Date())
            } else {
                let period = inputHourValue <= 12 ? "AM" : "PM"
                formattedHour = String(format: "%02d:00%@", inputHourValue % 12, period)
            }
            return formattedHour
        }
    }
}
