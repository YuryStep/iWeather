//
//  HomeViewPresenter.swift
//  iWeather
//
//  Created by Юрий Степанчук on 09.02.2024.
//

import Foundation

class HomeViewPresenter {
    private struct State {
        static var stubTimeLineItems = {
            var stubTimeLineItems = [TimelineCell.DisplayData]()
            for _ in 0 ..< 24 { stubTimeLineItems.append(TimelineCell.DisplayData()) }
            return stubTimeLineItems
        }()

        static var stubCityCellItems = [
            CityCell.DisplayData(cityName: "Москва", currentTemperature: "-5".addDegreeSymbol()),
            CityCell.DisplayData(cityName: "Казань", currentTemperature: "-17".addDegreeSymbol())
        ]

        var currentCity: CityWeatherInfo?
        var citiesWeatherInfo = [CityWeatherInfo]()
    }

    private weak var view: HomeViewController?
    private var networkService: NetworkService
    private var state: State = .init()

    init(view: HomeViewController?, networkService: NetworkService) {
        self.view = view
        self.networkService = networkService
        downloadWeatherInfoForPresetCities()
    }

    private func downloadWeatherInfoForPresetCities() {
        networkService.downloadWeatherInfo(for: PresetCity.allCases) { result in
            switch result {
            case let .success(citiesWeatherInfo):
                self.state.citiesWeatherInfo = citiesWeatherInfo
                self.state.currentCity = citiesWeatherInfo[0]
                self.view?.updateHomeView()
            case let .failure(error): print(error.localizedDescription)
            }
        }
    }
}

extension HomeViewPresenter: HomeViewOutput {
    func getCityCellDisplayData() -> [HomeCollectionView.Item] {
        guard !state.citiesWeatherInfo.isEmpty else {
            return State.stubCityCellItems.toCityItems()
        }
        return getCityCellItems().toCityItems()
    }

    func getTimelineCellDisplayData() -> [HomeCollectionView.Item] {
        guard !state.citiesWeatherInfo.isEmpty else { return State.stubTimeLineItems.toTimelineItems() }
        return getTimeLineItems().toTimelineItems()
    }

    func getCurrentCityCellDisplayData() -> [HomeCollectionView.Item] {
        return getCurrentCityCellDisplayData().toCurrentCityItems()
    }

    func didTapOnCell(at indexPath: IndexPath) {
        state.currentCity = state.citiesWeatherInfo[indexPath.row]
        view?.updateHomeView()
    }

    private func getCurrentCityCellDisplayData() -> [CurrentCityCell.DisplayData] {
        guard let currentCity = state.currentCity else { return [CurrentCityCell.displayDataStub] }
        return [CurrentCityCell.DisplayData(cityWeatherInfo: currentCity)]
    }

    private func getCityCellItems() -> [CityCell.DisplayData] {
        guard !state.citiesWeatherInfo.isEmpty else { return State.stubCityCellItems }
        var cityCellItems = [CityCell.DisplayData]()
        for weatherModel in state.citiesWeatherInfo {
            cityCellItems.append(CityCell.DisplayData(whetherModel: weatherModel))
        }
        return cityCellItems
    }

    private func getTimeLineItems() -> [TimelineCell.DisplayData] {
        guard let currentCity = state.currentCity else { return State.stubTimeLineItems }
        var timeLineItems = [TimelineCell.DisplayData]()
        for hourWeatherInfo in currentCity.forecasts[0].hours {
            timeLineItems.append(TimelineCell.DisplayData(hourWeatherInfo: hourWeatherInfo))
        }
        return timeLineItems
    }
}

private extension CurrentCityCell.DisplayData {
    init(cityWeatherInfo: CityWeatherInfo) {
        cityName = cityWeatherInfo.geoObject.locality.name
        currentTemperature = String(cityWeatherInfo.fact.temp!).addDegreeSymbol()
        temperatureRange = cityWeatherInfo.temperatureRange
        weatherCondition = cityWeatherInfo.fact.condition!
    }
}

private extension CityCell.DisplayData {
    init(whetherModel: CityWeatherInfo) {
        cityName = whetherModel.geoObject.locality.name
        currentTemperature = String(whetherModel.fact.temp!).addDegreeSymbol()
    }
}

private extension TimelineCell.DisplayData {
    init(hourWeatherInfo: HourWeatherInfo) {
        iconImageData = hourWeatherInfo.iconImageData
        temperature = String(hourWeatherInfo.temperature).addDegreeSymbol()
        time = hourWeatherInfo.hour.transformedTo12HourFormat()
    }
}
