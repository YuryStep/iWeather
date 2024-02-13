//
//  UILabel+Extensions.swift
//  iWeather
//
//  Created by Юрий Степанчук on 07.02.2024.
//

import UIKit

extension UILabel {
    convenience init(_ font: AppFont,
                     size: CGFloat,
                     color: UIColor = .white,
                     linesNumber: Int = 0,
                     alignment: NSTextAlignment = .center)
    {
        self.init()
        translatesAutoresizingMaskIntoConstraints = false
        adjustsFontForContentSizeCategory = true
        numberOfLines = linesNumber
        textAlignment = alignment
        textColor = color
        self.font = UIFont(name: font.rawValue, size: size)
    }
}
