//
//  HomeCollectionView.swift
//  iWeather
//
//  Created by Юрий Степанчук on 14.02.2024.
//

import UIKit

protocol HomeCollectionViewDelegate: AnyObject, UICollectionViewDelegate {
    func getCityCellDisplayData() -> [HomeCollectionView.Item]
    func getTimelineCellDisplayData() -> [HomeCollectionView.Item]
    func getCurrentCityCellDisplayData() -> [HomeCollectionView.Item]
}

final class HomeCollectionView: UICollectionView {
    private enum Constants {
        static let timelineHeaderKind = "timelineHeaderKind"
        static let cityItemPadding: CGFloat = 25
        static let cityItemSpacing: CGFloat = 25
        static let cityItemAspectRatio = 0.8
        static let timelineItemPadding: CGFloat = 25
        static let timelineItemSpacing: CGFloat = 25
        static let timelineItemAspectRatio = 0.75
    }

    enum Section: Int {
        case currentCity
        case cities
        case timeline
    }

    enum Item: Hashable {
        case currentCity(CurrentCityCell.DisplayData)
        case cityItem(CityCell.DisplayData)
        case timelineItem(TimelineCell.DisplayData)
    }

    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    private typealias TimelineHeaderRegistration = UICollectionView.SupplementaryRegistration<TimelineHeaderView>

    private var homeDataSource: DataSource!
    private var homeCollectionViewDelegate: HomeCollectionViewDelegate!

    init(frame: CGRect, delegate: HomeCollectionViewDelegate) {
        super.init(frame: frame, collectionViewLayout: UICollectionViewLayout())
        homeCollectionViewDelegate = delegate
        setupCollection()
        setLayout()
        configureDataSource()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCollection() {
        register(CityCell.self)
        register(TimelineCell.self)
        register(CurrentCityCell.self)
        delegate = homeCollectionViewDelegate
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        contentInsetAdjustmentBehavior = .never
    }

    private func configureDataSource() {
        homeDataSource = DataSource(collectionView: self) { collectionView, indexPath, itemIdentifier in
            guard let section = Section(rawValue: indexPath.section) else {
                assertionFailure("Failed to initialize Section in DataSource")
                return UICollectionViewCell()
            }

            switch section {
            case .currentCity:
                let cell = collectionView.reuse(CurrentCityCell.self, indexPath)
                if case let .currentCity(currentCityCellDisplayData) = itemIdentifier {
                    cell.configure(with: currentCityCellDisplayData)
                }
                return cell
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

        let supplementaryRegistration = TimelineHeaderRegistration(elementKind: Constants.timelineHeaderKind) { _, _, _ in }

        homeDataSource.supplementaryViewProvider = { _, _, index in
            self.dequeueConfiguredReusableSupplementary(using: supplementaryRegistration, for: index)
        }
    }

    private func setLayout() {
        let sectionProvider = { [weak self] (sectionIndex: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self, let section = Section(rawValue: sectionIndex) else {
                assertionFailure("Failed to initialize Section in SectionProvider")
                return nil
            }
            switch section {
            case .currentCity: return createCurrentCitySectionLayout()
            case .cities: return createCitiesSectionLayout()
            case .timeline: return createTimelineSectionLayout()
            }
        }

        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
        collectionViewLayout = layout
    }

    private func createCurrentCitySectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .fitToParent)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalHeight(0.4))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
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
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
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

        let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: titleSize,
            elementKind: Constants.timelineHeaderKind,
            alignment: .topLeading
        )
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }

    func applySnapshot(animatingDifferences: Bool) {
        let currentCityItem = homeCollectionViewDelegate.getCurrentCityCellDisplayData()
        let citiesItems = homeCollectionViewDelegate.getCityCellDisplayData()
        let timelineItems = homeCollectionViewDelegate.getTimelineCellDisplayData()

        var snapshot = Snapshot()
        snapshot.appendSections([.currentCity, .cities, .timeline])
        snapshot.appendItems(currentCityItem, toSection: .currentCity)
        snapshot.appendItems(citiesItems, toSection: .cities)
        snapshot.appendItems(timelineItems, toSection: .timeline)

        homeDataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    private func getLayoutSizeToFitItems(count itemsCount: CGFloat, padding: CGFloat, spacing: CGFloat, aspectRatio: CGFloat) -> NSCollectionLayoutSize {
        let width = (frame.width - spacing) / itemsCount - padding
        let height = width / aspectRatio
        let size = NSCollectionLayoutSize(widthDimension: .absolute(width), heightDimension: .absolute(height))
        return size
    }
}
