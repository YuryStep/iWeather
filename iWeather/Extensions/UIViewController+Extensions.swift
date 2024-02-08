//
//  UIViewController+Extensions.swift
//  iWeather
//
//  Created by Юрий Степанчук on 08.02.2024.
//

import UIKit

extension UIViewController {
    func wrappedInNavigationController() -> UINavigationController {
        return UINavigationController(rootViewController: self)
    }
}
