//
//  HomeViewController.swift
//  iWeather
//
//  Created by Юрий Степанчук on 07.02.2024.
//

import UIKit

final class HomeViewController: UIViewController, UICollectionViewDelegate {
    private enum Constants {
        static let profileButtonImageName = "iconPerson"
        static let profileButtonWidth: CGFloat = 34
        static let profileButtonHeight: CGFloat = 34

        static let menuButtonImageName = "iconBurger"
        static let menuButtonWidth: CGFloat = 34
        static let menuButtonHeight: CGFloat = 18

        static let cityItemPadding: CGFloat = 25
        static let cityItemSpacing: CGFloat = 25
        static let cityItemAspectRatio = 0.8

        static let timelineItemPadding: CGFloat = 25
        static let timelineItemSpacing: CGFloat = 25
        static let timelineItemAspectRatio = 0.75
    }

    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    private typealias TimelineHeaderRegistration = UICollectionView.SupplementaryRegistration<TimelineHeaderView>

    private enum Section: Int {
        case cities
        case timeline
    }

    enum Item: Hashable {
        case cityItem(CityCell.DisplayData)
        case timelineItem(TimelineCell.DisplayData)
    }

    private var dataSource: DataSource!

    private lazy var profileButton = UIButton(assetsImage: Constants.profileButtonImageName,
                                              width: Constants.profileButtonWidth,
                                              height: Constants.profileButtonHeight)

    private lazy var menuButton = UIButton(assetsImage: Constants.menuButtonImageName,
                                           width: Constants.menuButtonWidth,
                                           height: Constants.menuButtonHeight)

    private lazy var topView = TopView(frame: .zero, displayData: TopView.displayDataStub)

    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CityCell.self)
        collectionView.register(TimelineCell.self)
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        configureDataSource()
        setupView()
        applySnapshot(animatingDifferences: false)
    }

    private func setupNavigationBar() {
        let leftBarButtonItem = UIBarButtonItem(customView: profileButton)
        let rightBarButtonItem = UIBarButtonItem(customView: menuButton)
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }

    private func setupView() {
        view.backgroundColor = .appBackground
        view.addSubviews([topView, collectionView])
        NSLayoutConstraint.activate([
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.topAnchor.constraint(equalTo: view.topAnchor),
            topView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.4252),

            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func configureDataSource() {
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            guard let section = Section(rawValue: indexPath.section) else {
                assertionFailure("Failed to initialize Section in DataSource")
                return UICollectionViewCell()
            }

            switch section {
            case .cities:
                let cell = collectionView.reuse(CityCell.self, indexPath)
                if case let .cityItem(cityCellDisplayData) = itemIdentifier {
                    cell.configure(with: cityCellDisplayData)
                }
                return cell
            case .timeline:
                let cell = collectionView.reuse(TimelineCell.self, indexPath)
                if case let .timelineItem(timelineCellDisplayData) = itemIdentifier {
                    cell.configure(with: timelineCellDisplayData)
                }
                return cell
            }
        }

        let supplementaryRegistration = TimelineHeaderRegistration(elementKind: "title-element-kind") { (_, _, _) in
        }

        dataSource.supplementaryViewProvider = { (_, _, index) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(
                using: supplementaryRegistration, for: index)
        }
    }

    private func createLayout() -> UICollectionViewCompositionalLayout {
        let sectionProvider = { [weak self] (sectionIndex: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self, let section = Section(rawValue: sectionIndex) else {
                assertionFailure("Failed to initialize Section in SectionProvider")
                return nil
            }
            switch section {
            case .cities: return createCitiesSectionLayout()
            case .timeline: return createTimelineSectionLayout()
            }
        }

        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
        return layout
    }

    private func createCitiesSectionLayout() -> NSCollectionLayoutSection {
        let dynamicSize = getLayoutSizeToFitItems(count: 2,
                                                  padding: Constants.cityItemPadding,
                                                  spacing: Constants.cityItemSpacing,
                                                  aspectRatio: Constants.cityItemAspectRatio)

        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize.fitToParent)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: dynamicSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Constants.cityItemSpacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 25,
                                                        leading: Constants.cityItemPadding,
                                                        bottom: 10,
                                                        trailing: Constants.cityItemPadding)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }

    private func createTimelineSectionLayout() -> NSCollectionLayoutSection {
        let dynamicSize = getLayoutSizeToFitItems(count: 4,
                                                  padding: Constants.timelineItemPadding,
                                                  spacing: Constants.timelineItemSpacing,
                                                  aspectRatio: Constants.timelineItemAspectRatio)

        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize.fitToParent)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: dynamicSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = Constants.timelineItemSpacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                        leading: Constants.timelineItemPadding,
                                                        bottom: 0,
                                                        trailing: Constants.timelineItemPadding)
        // Header
        let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(44))
        let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: titleSize,
            elementKind: "title-element-kind",
            alignment: .topLeading)
        section.boundarySupplementaryItems = [titleSupplementary]
        return section
    }

    private func applySnapshot(animatingDifferences: Bool) {
        let citiesItems = [
            HomeViewController.Item.cityItem(CityCell.displayDataStub1),
            HomeViewController.Item.cityItem(CityCell.displayDataStub2),
            HomeViewController.Item.cityItem(CityCell.displayDataStub3),
            HomeViewController.Item.cityItem(CityCell.displayDataStub4),
            HomeViewController.Item.cityItem(CityCell.displayDataStub5)
        ]
        let timelineItems = [
            HomeViewController.Item.timelineItem(TimelineCell.displayDataStub1),
            HomeViewController.Item.timelineItem(TimelineCell.displayDataStub2),
            HomeViewController.Item.timelineItem(TimelineCell.displayDataStub3),
            HomeViewController.Item.timelineItem(TimelineCell.displayDataStub4),
            HomeViewController.Item.timelineItem(TimelineCell.displayDataStub5)
        ]

        var snapshot = Snapshot()
        snapshot.appendSections([.cities, .timeline])
        snapshot.appendItems(citiesItems, toSection: .cities)
        snapshot.appendItems(timelineItems, toSection: .timeline)

        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    private func getLayoutSizeToFitItems(count itemsCount: CGFloat, padding: CGFloat, spacing: CGFloat, aspectRatio: CGFloat) -> NSCollectionLayoutSize {
        let width = (view.frame.width - spacing) / itemsCount - padding
        let height = width / aspectRatio
        let size = NSCollectionLayoutSize(widthDimension: .absolute(width), heightDimension: .absolute(height))
        return size
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
