//
//  HomeController.swift
//  iWeather
//
//  Created by Юрий Степанчук on 07.02.2024.
//

import UIKit

final class HomeController: UIViewController {
    private enum Constants {
        static let stabText = "Раздел в разработке"
    }

    private lazy var topView: TopView = {
        let view = TopView(frame: CGRect(), displayData: TopView.displayDataStub)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.backgroundColor = .appBackground
        view.addSubview(topView)
        NSLayoutConstraint.activate([
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.topAnchor.constraint(equalTo: view.topAnchor),
            topView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.4252)
        ])
    }
}
