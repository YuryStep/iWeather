//
//  LocationAssembly.swift
//  iWeather
//
//  Created by Юрий Степанчук on 07.02.2024.
//

import UIKit

enum LocationAssembly {
    static func makeModule() -> UIViewController {
        let locationController = LocationViewController()
        return locationController
    }
}
