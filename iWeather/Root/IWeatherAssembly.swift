//
//  IWeatherAssembly.swift
//  iWeather
//
//  Created by Юрий Степанчук on 07.02.2024.
//

import UIKit

enum IWeatherAssembly {
    static func makeModule() -> UIViewController {
        let home = HomeAssembly.makeModule()
        let search = SearchAssembly.makeModule()
        let location = LocationAssembly.makeModule()
        let settings = SettingsAssembly.makeModule()

        let tabBarController = makeTabBarController(with: [home, search, location, settings])
        tabBarController.tabBar.tintColor = .appLightBackground
        return tabBarController
    }

    private static func makeTabBarController(with viewControllers: [UIViewController]) -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = viewControllers
        turnOffTabBarTransparency()
        return tabBarController
    }

    private static func turnOffTabBarTransparency() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
}
