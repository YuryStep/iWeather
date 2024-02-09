//
//  HomeAssembly.swift
//  iWeather
//
//  Created by Юрий Степанчук on 07.02.2024.
//

import UIKit

enum HomeAssembly {
    static func makeModule() -> UIViewController {
        let homeController = HomeViewController()
        return homeController.wrappedInNavigationController()
    }
}
