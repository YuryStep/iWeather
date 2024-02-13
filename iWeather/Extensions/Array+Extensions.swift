//
//  Array+Extensions.swift
//  iWeather
//
//  Created by Юрий Степанчук on 12.02.2024.
//

import Foundation

extension Array where Element == CityCell.DisplayData {
    func toCityItems() -> [HomeViewController.Item] {
        return self.map { .cityItem($0) }
    }
}

extension Array where Element == TimelineCell.DisplayData {
    func toTimelineItems() -> [HomeViewController.Item] {
        return self.map { .timelineItem($0) }
    }
}
