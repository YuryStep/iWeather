//
//  MainTabBarController.swift
//  iWeather
//
//  Created by Юрий Степанчук on 08.02.2024.
//

import UIKit

final class MainTabBarController: UITabBarController {
    private enum Constants {
        static let cornerRadius: CGFloat = 15
        static let iconImageSquareSize: CGFloat = 40
        static let homeTabImageName = "tabBarIconHome"
        static let searchTabImageName = "tabBarIconSearch"
        static let locationTabImageName = "tabBarIconCompass"
        static let settingsTabImageName = "tabBarIconSettings"
    }

    private var homeVC: UIViewController?
    private var searchVC: UIViewController?
    private var locationVC: UIViewController?
    private var settingsVC: UIViewController?

    init(homeVC: UIViewController, searchVC: UIViewController, locationVC: UIViewController, settingsVC: UIViewController) {
        super.init(nibName: nil, bundle: nil)
        self.homeVC = homeVC
        self.searchVC = searchVC
        self.locationVC = locationVC
        self.settingsVC = settingsVC
        setupTabBarControllers()
        setTabBarAppearance()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("This class does not support NSCoder")
    }

    private func setupTabBarControllers() {
        viewControllers = [
            configure(homeVC, image: UIImage(named: Constants.homeTabImageName)),
            configure(searchVC, image: UIImage(named: Constants.searchTabImageName)),
            configure(locationVC, image: UIImage(named: Constants.locationTabImageName)),
            configure(settingsVC, image: UIImage(named: Constants.settingsTabImageName))
        ]
    }

    private func configure(_ viewController: UIViewController?, title: String = "", image: UIImage?) -> UIViewController {
        guard let viewController = viewController else { return UIViewController() }
        let size = Constants.iconImageSquareSize
        let resizedImage = image?.resized(to: CGSize(width: size, height: size))
        viewController.tabBarItem.image = resizedImage
        viewController.tabBarItem.title = title
        return viewController
    }

    private func setTabBarAppearance() {
        tabBar.itemPositioning = .centered
        tabBar.tintColor = .appAccent
        tabBar.backgroundColor = .appLightBackground
        tabBar.unselectedItemTintColor = .appInactiveTabBarItem
        tabBar.layer.cornerRadius = Constants.cornerRadius
    }
}
