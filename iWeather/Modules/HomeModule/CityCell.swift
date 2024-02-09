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
        let imageName: String
        let cityName: String = "Jaipur"
        let currentTemperature: String = "30°C"
    }

    private enum Constants {
        static let padding: CGFloat = 20
        static let labelTextSize: CGFloat = 20
    }

    //  TODO: Remove when Networking will be done
    static var displayDataStub1 = DisplayData(imageName: "cityImageStub")
    static var displayDataStub2 = DisplayData(imageName: "cityImageStub")
    static var displayDataStub3 = DisplayData(imageName: "cityImageStub")
    static var displayDataStub4 = DisplayData(imageName: "cityImageStub")
    static var displayDataStub5 = DisplayData(imageName: "cityImageStub")

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

            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.padding)
        ])
    }
}
