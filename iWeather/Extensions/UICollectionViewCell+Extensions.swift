//
//  UICollectionViewCell+Extensions.swift
//  iWeather
//
//  Created by Юрий Степанчук on 08.02.2024.
//

import UIKit

extension UICollectionViewCell {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}
