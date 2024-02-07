//
//  SettingsAssembly.swift
//  iWeather
//
//  Created by Юрий Степанчук on 07.02.2024.
//

import UIKit

enum SettingsAssembly {
    private enum Constants {
        static let tabIconName = "Settings"
        static let tabImageName = "gearshape"
    }

    static func makeModule() -> UIViewController {
        let settingsController = SettingsController()

        let tabImage = UIImage(systemName: Constants.tabImageName)
        settingsController.tabBarItem = UITabBarItem(title: Constants.tabIconName, image: tabImage, tag: 3)

        return settingsController
    }
}
