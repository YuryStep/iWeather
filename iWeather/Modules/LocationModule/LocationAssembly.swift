//
//  LocationAssembly.swift
//  iWeather
//
//  Created by Юрий Степанчук on 07.02.2024.
//

import UIKit

enum LocationAssembly {
    private enum Constants {
        static let tabIconName = "location"
        static let tabImageName = "location.circle"
    }

    static func makeModule() -> UIViewController {
        let locationController = LocationController()

        let tabImage = UIImage(systemName: Constants.tabImageName)
        locationController.tabBarItem = UITabBarItem(title: Constants.tabIconName, image: tabImage, tag: 2)

        return locationController
    }
}
