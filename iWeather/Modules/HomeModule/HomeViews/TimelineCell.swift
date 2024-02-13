//
//  TimelineCell.swift
//  iWeather
//
//  Created by Юрий Степанчук on 08.02.2024.
//

import UIKit

final class TimelineCell: UICollectionViewCell {
    struct DisplayData: Equatable, Hashable {
        let id = UUID()
        var iconImageData: Data?
        var temperature: String = "25°C"
        var time: String = "1:00PM"
    }

    private enum Constants {
        static let temperatureLabelTextSize: CGFloat = 15
        static let timeLabelTextSize: CGFloat = 15
    }

    private lazy var backView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .appTodayWeatherCellBackground
        view.layer.cornerRadius = 16
        return view
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var temperatureLabel = UILabel(.poppinsMedium, size: Constants.temperatureLabelTextSize)
    private lazy var timeLabel = UILabel(.poppinsSemiBold, size: Constants.timeLabelTextSize)

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("This class does not support NSCoder")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        backgroundColor = .clear
    }

    func configure(with displayData: DisplayData) {
        if let imageData = displayData.iconImageData,
            let image = UIImage(data: imageData) {
            imageView.image = image
        } else {
            debugPrint("UIImage cannot work with SVG. stub used")
            imageView.image = UIImage(named: "weatherIconCloudsStub")
        }
        temperatureLabel.text = displayData.temperature
        timeLabel.text = displayData.time
    }

    private func setupSubviews() {
        contentView.addSubviews([backView, imageView, temperatureLabel, timeLabel])
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),

            temperatureLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            temperatureLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),

            backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backView.bottomAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 5),

            timeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            timeLabel.topAnchor.constraint(equalTo: backView.bottomAnchor, constant: 5)
        ])
    }
}
