//
//  NSCollectionLayoutSize+Extensions.swift
//  iWeather
//
//  Created by Юрий Степанчук on 09.02.2024.
//

import UIKit

extension NSCollectionLayoutSize {
    static var fitToParent: NSCollectionLayoutSize {
        return NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
    }
}
