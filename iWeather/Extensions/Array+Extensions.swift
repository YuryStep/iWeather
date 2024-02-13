//
//  Array+Extensions.swift
//  iWeather
//
//  Created by Юрий Степанчук on 12.02.2024.
//

import Foundation

extension Array where Element == CurrentCityCell.DisplayData {
    func toCurrentCityItems() -> [HomeViewController.Item] {
        return map { .currentCity($0) }
    }
}

extension Array where Element == CityCell.DisplayData {
    func toCityItems() -> [HomeViewController.Item] {
        return map { .cityItem($0) }
    }
}

extension Array where Element == TimelineCell.DisplayData {
    func toTimelineItems() -> [HomeViewController.Item] {
        return map { .timelineItem($0) }
    }
}
