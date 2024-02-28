//
//  HomeViewPresenter.swift
//  iWeather
//
//  Created by Юрий Степанчук on 09.02.2024.
//

import Foundation

class HomeViewPresenter {
    private struct State {
        var currentCity: CityWeatherInfo?
        var citiesWeatherInfo = [CityWeatherInfo]()
    }

    private weak var view: HomeViewInput?
    private var networkService: AppNetworkService
    private var state: State

    init(view: HomeViewController?, networkService: AppNetworkService) {
        self.view = view
        state = State()
        self.networkService = networkService
        downloadWeatherInfoForPresetCities()
    }

    private func downloadWeatherInfoForPresetCities() {
        networkService.downloadWeatherInfo(for: PresetCity.allCases) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(citiesWeatherInfo):
                self.state.citiesWeatherInfo = citiesWeatherInfo
                self.state.currentCity = citiesWeatherInfo.first
                self.view?.updateView()
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
}

extension HomeViewPresenter: HomeViewOutput {
    func getCityCellDisplayData() -> [HomeCollectionView.Item] {
        guard !state.citiesWeatherInfo.isEmpty else { return Stub.stubCityCellDisplayData.toCityItems() }
        var cityCellDisplayData = [CityCell.DisplayData]()
        for cityWeatherInfo in state.citiesWeatherInfo {
            cityCellDisplayData.append(CityCell.DisplayData(whetherModel: cityWeatherInfo))
        }
        return cityCellDisplayData.toCityItems()
    }

    func getTimelineCellDisplayData() -> [HomeCollectionView.Item] {
        guard let currentCity = state.currentCity else { return Stub.stubTimeLineCellDisplayData.toTimelineItems() }
        var timeLineDisplayData = [TimelineCell.DisplayData]()
        for hourWeatherInfo in currentCity.forecasts[0].hours {
            timeLineDisplayData.append(TimelineCell.DisplayData(hourWeatherInfo: hourWeatherInfo))
        }
        return timeLineDisplayData.toTimelineItems()
    }

    func getCurrentCityCellDisplayData() -> [HomeCollectionView.Item] {
        guard let currentCity = state.currentCity else { return Stub.stubCurrentCityCellDisplayData.toCurrentCityItems() }
        return [CurrentCityCell.DisplayData(cityWeatherInfo: currentCity)].toCurrentCityItems()
    }

    func didTapOnCell(at indexPath: IndexPath) {
        state.currentCity = state.citiesWeatherInfo[indexPath.row]
        view?.updateView()
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

private enum Stub {
    static var stubCurrentCityCellDisplayData = [CurrentCityCell.DisplayData(
        cityName: "Hyderabad",
        temperatureRange: "20°C/29°C",
        currentTemperature: "24°C",
        weatherCondition: "Clear sky"
    )]

    static var stubTimeLineCellDisplayData = {
        var stubTimeLineItems = [TimelineCell.DisplayData]()
        for _ in 0 ..< 24 {
            stubTimeLineItems.append(TimelineCell.DisplayData())
        }
        return stubTimeLineItems
    }()

    static var stubCityCellDisplayData = [
        CityCell.DisplayData(cityName: "Москва", currentTemperature: "-5".addDegreeSymbol()),
        CityCell.DisplayData(cityName: "Казань", currentTemperature: "-17".addDegreeSymbol())
    ]
}
