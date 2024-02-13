//
//  HomeAssembly.swift
//  iWeather
//
//  Created by Юрий Степанчук on 07.02.2024.
//

import UIKit

enum HomeAssembly {
    static func makeModule() -> UIViewController {
        let homeViewController = HomeViewController()
        let presenter = HomeViewPresenter(view: homeViewController, networkService: NetworkService())
        homeViewController.presenter = presenter
        return homeViewController.wrappedInNavigationController()
    }
}
