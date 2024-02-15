//
//  HomeViewController.swift
//  iWeather
//
//  Created by Юрий Степанчук on 07.02.2024.
//

import UIKit

protocol HomeViewOutput {
    func getCityCellDisplayData() -> [HomeCollectionView.Item]
    func getTimelineCellDisplayData() -> [HomeCollectionView.Item]
    func getCurrentCityCellDisplayData() -> [HomeCollectionView.Item]
    func didTapOnCell(at indexPath: IndexPath)
}

protocol HomeViewInput {
    func updateHomeView()
}

final class HomeViewController: UIViewController {
    private enum Constants {
        static let profileButtonImageName = "iconPerson"
        static let profileButtonWidth: CGFloat = 34
        static let profileButtonHeight: CGFloat = 34

        static let menuButtonImageName = "iconBurger"
        static let menuButtonWidth: CGFloat = 34
        static let menuButtonHeight: CGFloat = 18

        static let alertTitle = "Hello World"
        static let alertButtonText = "OK"
    }

    var presenter: HomeViewOutput!

    private lazy var profileButton: UIButton = {
        let button = UIButton(assetsImage: Constants.profileButtonImageName,
                              width: Constants.profileButtonWidth,
                              height: Constants.profileButtonHeight)
        button.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var menuButton: UIButton = {
        let button = UIButton(assetsImage: Constants.menuButtonImageName,
                              width: Constants.menuButtonWidth,
                              height: Constants.menuButtonHeight)
        button.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var collectionView: HomeCollectionView = {
        let collectionView = HomeCollectionView(frame: .zero, delegate: self)
        return collectionView
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
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func profileButtonTapped() {
        let alertController = UIAlertController(title: Constants.alertTitle, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Constants.alertButtonText, style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    @objc private func menuButtonTapped() {
        let greenViewController = UIViewController()
        greenViewController.view.backgroundColor = .systemGreen
        navigationController?.pushViewController(greenViewController, animated: true)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section == HomeCollectionView.Section.cities.rawValue else { return }
        presenter.didTapOnCell(at: indexPath)
    }
}

extension HomeViewController: HomeViewInput {
    func updateHomeView() {
        collectionView.applySnapshot(animatingDifferences: true)
        scrollHourTimelineToNowItem()
    }

    private func scrollHourTimelineToNowItem() {
        let itemNumber = currentHour()
        let sectionNumber = HomeCollectionView.Section.timeline.rawValue
        let indexPath = IndexPath(item: itemNumber, section: sectionNumber)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }

    private func currentHour() -> Int {
        let currentDate = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: currentDate)
        return hour
    }
}

extension HomeViewController: HomeCollectionViewDelegate {
    func getCityCellDisplayData() -> [HomeCollectionView.Item] {
        presenter.getCityCellDisplayData()
    }

    func getTimelineCellDisplayData() -> [HomeCollectionView.Item] {
        presenter.getTimelineCellDisplayData()
    }

    func getCurrentCityCellDisplayData() -> [HomeCollectionView.Item] {
        presenter.getCurrentCityCellDisplayData()
    }
}
