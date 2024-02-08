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

    private lazy var profileButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .appAccent
        let systemImageConfiguration = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)
        let image = UIImage(systemName: "person.circle")?.withConfiguration(systemImageConfiguration)
        button.setImage(image, for: .normal)
        return button
    }()

    private lazy var menuButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .appAccent
        let systemImageConfiguration = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)
        let image = UIImage(systemName: "line.3.horizontal")?.withConfiguration(systemImageConfiguration)
        button.setImage(image, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
    }

    private func setupNavigationBar() {
        let leftBarButtonItem = UIBarButtonItem(customView: profileButton)
        let rightBarButtonItem = UIBarButtonItem(customView: menuButton)
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }

    private func setupView() {
        view.backgroundColor = .appBackground
        view.addSubview(topView)
        let statusBarHeight = getStatusBarHeight()
        NSLayoutConstraint.activate([
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.topAnchor.constraint(equalTo: view.topAnchor),
            topView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.4252)
        ])
    }

    // TODO: Remove If not needed
    private func getStatusBarHeight() -> CGFloat {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let statusBarManager = windowScene.statusBarManager else {
            return 0
        }
        return statusBarManager.statusBarFrame.size.height
    }
}
