//
//  UIImage+Extensions.swift
//  iWeather
//
//  Created by Юрий Степанчук on 09.02.2024.
//

import UIKit

extension UIImage {
    func resize(to newSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let resizedImage = renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
        return resizedImage
    }
}
