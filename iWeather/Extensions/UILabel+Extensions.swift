//
//  UILabel+Extensions.swift
//  iWeather
//
//  Created by Юрий Степанчук on 07.02.2024.
//

import UIKit

extension UILabel {
    convenience init(_ font: AppFont, size: CGFloat,  color: UIColor = .white) {
        self.init()
        translatesAutoresizingMaskIntoConstraints = false
        adjustsFontForContentSizeCategory = true
        textColor = color
        self.font = UIFont(name: font.rawValue, size: size)
    }
}
