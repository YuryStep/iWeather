//
//  UIButton+Extensions.swift
//  iWeather
//
//  Created by Юрий Степанчук on 08.02.2024.
//

import UIKit

extension UIButton {
    convenience init(systemImage: String, imageFontSize: CGFloat, color: UIColor = .appAccent) {
        self.init()
        translatesAutoresizingMaskIntoConstraints = false
        tintColor = color
        let systemImageConfiguration = UIImage.SymbolConfiguration(pointSize: imageFontSize, weight: .regular)
        let image = UIImage(systemName: systemImage)?.withConfiguration(systemImageConfiguration)
        setImage(image, for: .normal)
    }

    convenience init(assetsImage: String, width: CGFloat, height: CGFloat, color: UIColor = .appAccent) {
        self.init()
        translatesAutoresizingMaskIntoConstraints = false
        tintColor = color
        if let image = UIImage(named: assetsImage) {
            let newImageSize = CGSize(width: width, height: height)
            let resizedImage = image.resized(to: newImageSize)
            setImage(resizedImage, for: .normal)
        }
    }
}
