//
//  HomeAssembly.swift
//  iWeather
//
//  Created by Юрий Степанчук on 07.02.2024.
//

import UIKit

enum HomeAssembly {
    private enum Constants {
        static let tabIconName = "Home"
        static let tabImageName = "house.fill"
    }

    static func makeModule() -> UIViewController {
        let homeController = HomeController()

//        let tabImage = UIImage(systemName: Constants.tabImageName)
//        homeController.tabBarItem = UITabBarItem(title: Constants.tabIconName, image: tabImage, tag: 0)

        return homeController.wrappedInNavigationController()
    }
}
