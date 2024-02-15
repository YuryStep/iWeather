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
        let networkService = NetworkService()
        let presenter = HomeViewPresenter(view: homeViewController, networkService: networkService)
        homeViewController.presenter = presenter
        return homeViewController.wrappedInNavigationController()
    }
}
