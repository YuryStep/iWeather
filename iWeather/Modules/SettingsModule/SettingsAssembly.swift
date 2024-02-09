//
//  SettingsAssembly.swift
//  iWeather
//
//  Created by Юрий Степанчук on 07.02.2024.
//

import UIKit

enum SettingsAssembly {
    static func makeModule() -> UIViewController {
        let settingsController = SettingsViewController()
        return settingsController
    }
}
