//
//  CityCell.swift
//  iWeather
//
//  Created by Юрий Степанчук on 08.02.2024.
//

import UIKit

final class CityCell: UICollectionViewCell {
    struct DisplayData: Equatable, Hashable {
        let id = UUID()
        var imageName: String = "cityImageStub"
        var cityName: String = "Jaipur"
        var currentTemperature: String = "30°C"
    }

    private enum Constants {
        static let padding: CGFloat = 20
        static let labelTextSize: CGFloat = 18
    }

    private lazy var label = UILabel(.poppinsSemiBold, size: Constants.labelTextSize)

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("This class does not support NSCoder")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        backgroundColor = .clear
        contentView.layer.cornerRadius = 22.0
        contentView.layer.masksToBounds = true
    }

    func configure(with displayData: DisplayData) {
        if let image = UIImage(named: displayData.imageName) {
            imageView.image = image
            label.text = "\(displayData.cityName) \(displayData.currentTemperature)"
        }
    }

    private func setupSubviews() {
        contentView.addSubviews([imageView, label])
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.padding)
        ])
    }
}
