//
//  TimelineHeaderView.swift
//  iWeather
//
//  Created by Юрий Степанчук on 08.02.2024.
//

import UIKit

class TimelineHeaderView: UICollectionReusableView {
    private enum Constants {
        static let labelText = "Today"
        static let labelTextSize: CGFloat = 20
    }

    static let reuseIdentifier = "title-supplementary-reuse-identifier"

    private lazy var label = UILabel(.poppinsMedium, size: Constants.labelTextSize)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError()
    }
}

extension TimelineHeaderView {
    func configure() {
        addSubview(label)
        label.text = Constants.labelText
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
