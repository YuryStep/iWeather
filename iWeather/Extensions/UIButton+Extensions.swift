//
//  UIButton+Extensions.swift
//  iWeather
//
//  Created by Юрий Степанчук on 08.02.2024.
//

import UIKit

extension UIButton {
    convenience init(systemImage: String, size: CGFloat = 30, color: UIColor = .appAccent) {
        self.init()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.tintColor = color
        let systemImageConfiguration = UIImage.SymbolConfiguration(pointSize: size, weight: .regular)
        let image = UIImage(systemName: systemImage)?.withConfiguration(systemImageConfiguration)
        self.setImage(image, for: .normal)
    }
}
