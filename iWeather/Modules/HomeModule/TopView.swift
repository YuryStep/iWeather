//
//  TopView.swift
//  iWeather
//
//  Created by Юрий Степанчук on 07.02.2024.
//

import UIKit

final class TopView: UIView {
    struct DisplayData {
        let cityName: String
        let date: String
        let temperatureRange: String
        let currentTemperature: String
        let weatherCondition: String
        let backgroundImage: UIImage
    }

    private enum Constants {
        static let bottomCornersRadius: CGFloat = 30

        static let padding: CGFloat = 25
        static let leftLabelSpacing: CGFloat = 15
        static let rightLabelSpacing: CGFloat = 5

        static let cityNameSize: CGFloat = 28
        static let temperatureInfoSize: CGFloat = 36
        static let dateAndRangeSize: CGFloat = 12.91
        static let weatherConditionSize: CGFloat = 21.33
        static let swipeLabelSize: CGFloat = 12
        static let swipeDownImageSize: CGFloat = 22

        static let swipeDownIconWidth: CGFloat = 20
        static let swipeDownIconHeigh: CGFloat = 10

        static let swipeDownImageName = "iconChevronDown"
        static let swipeLabelText = "Swipe down for details"
    }

    //  TODO: Remove when Networking will be done
    static var displayDataStub = DisplayData(
        cityName: "Hyderabad",
        date: "20 Apr Wed",
        temperatureRange: "20°C/29°C",
        currentTemperature: "24°C",
        weatherCondition: "Clear sky",
        backgroundImage: UIImage(named: "topImageStub")!
    )

    private lazy var cityLabel = UILabel(.poppinsSemiBold, size: Constants.cityNameSize)
    private lazy var temperatureLabel = UILabel(.poppinsSemiBold, size: Constants.temperatureInfoSize)
    private lazy var dateAndRangeLabel = UILabel(.poppinsRegular, size: Constants.dateAndRangeSize)
    private lazy var weatherCondition = UILabel(.poppinsRegular, size: Constants.weatherConditionSize)
    private lazy var swipeLabel = UILabel(.robotoRegular, size: Constants.swipeLabelSize, color: .appSwipeLabel)

    private lazy var swipeDownButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .appSwipeDownButton
        let imageIcon = getSwipeDownIcon()
        button.setImage(imageIcon, for: .normal)
        return button
    }()

    private lazy var swipeStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [swipeLabel, swipeDownButton])
        stack.axis = .vertical
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    init(frame: CGRect, displayData: DisplayData) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        makeBottomCornersRounded(radius: Constants.bottomCornersRadius)
        updateUI(with: displayData)
        setupSubviews()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("This class does not support NSCoder")
    }

    func updateUI(with displayData: DisplayData) {
        backgroundImageView.image = displayData.backgroundImage
        cityLabel.text = displayData.cityName
        dateAndRangeLabel.text = "\(displayData.date) \(displayData.temperatureRange)"
        temperatureLabel.text = displayData.currentTemperature
        swipeLabel.text = Constants.swipeLabelText
        weatherCondition.text = displayData.weatherCondition
    }

    private func makeBottomCornersRounded(radius: CGFloat) {
        layer.cornerRadius = radius
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        clipsToBounds = true
    }

    private func getSwipeDownIcon() -> UIImage {
        guard let image = UIImage(named: Constants.swipeDownImageName) else {
            assertionFailure("Failed to get swipeDownIcon by constant image name")
            fatalError()
        }
        let iconWidth = Constants.swipeDownIconWidth
        let iconHeight = Constants.swipeDownIconHeigh
        let iconSize = CGSize(width: iconWidth, height: iconHeight)
        let resizedIcon = image.resized(to: iconSize)
        return resizedIcon
    }

    private func setupSubviews() {
        addSubviews([backgroundImageView, cityLabel, dateAndRangeLabel, temperatureLabel, weatherCondition, swipeStackView])
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),

            cityLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            cityLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.padding),

            temperatureLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            trailingAnchor.constraint(equalTo: temperatureLabel.trailingAnchor, constant: Constants.padding),

            dateAndRangeLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: Constants.leftLabelSpacing),
            dateAndRangeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.padding),

            weatherCondition.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: Constants.rightLabelSpacing),
            trailingAnchor.constraint(equalTo: weatherCondition.trailingAnchor, constant: Constants.padding),

            swipeStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            swipeStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
