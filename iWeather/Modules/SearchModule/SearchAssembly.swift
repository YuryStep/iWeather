//
//  SearchAssembly.swift
//  iWeather
//
//  Created by Юрий Степанчук on 07.02.2024.
//

import UIKit

enum SearchAssembly {
    static func makeModule() -> UIViewController {
        let searchController = SearchViewController()
        return searchController
    }
}
