//
//  SearchAssembly.swift
//  iWeather
//
//  Created by Юрий Степанчук on 07.02.2024.
//

import UIKit

enum SearchAssembly {
    private enum Constants {
        static let tabIconName = "Search"
        static let tabImageName = "magnifyingglass"
    }

    static func makeModule() -> UIViewController {
        let searchController = SearchController()

//        let tabImage = UIImage(systemName: Constants.tabImageName)
//        searchController.tabBarItem = UITabBarItem(title: Constants.tabIconName, image: tabImage, tag: 1)

        return searchController
    }
}
