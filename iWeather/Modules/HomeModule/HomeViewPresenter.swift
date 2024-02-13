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
            for _ in 0..<24 {
                stubTimeLineItems.append(TimelineCell.DisplayData())
            }
            return stubTimeLineItems
        }()

        static var stubCityCellItems = [
                CityCell.DisplayData(imageName: "cityImageStub",
                                     cityName: "Москва",
                                     currentTemperature: "-5".addDegreeSymbol()),
                CityCell.DisplayData(imageName: "cityImageStub",
                                     cityName: "Казань",
                                     currentTemperature: "-17".addDegreeSymbol())
        ]
        var currentCity: CityWeatherInfo?
        var citiesWeatherInfo = [CityWeatherInfo]()
    }

    private weak var view: HomeViewController?
    private var networkService: NetworkService
    private var state: State = State()

    init(view: HomeViewController?, networkService: NetworkService) {
        self.view = view
        self.networkService = networkService
        downloadWeatherInfoForPresetCitities()
    }

    private func downloadWeatherInfoForPresetCitities() {
        networkService.downloadWeatherInfo(for: PresetCity.allCases ) { result in
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
    func getTopViewDisplayData() -> TopView.DisplayData {
        TopView.DisplayData(cityWeatherInfo: state.currentCity!)
    }

    func getCityCellDisplayData() -> [HomeViewController.Item] {
        guard !state.citiesWeatherInfo.isEmpty else {
            return State.stubCityCellItems.toCityItems()
        }
        return getCityCellItems().toCityItems()
    }

    func getTimelineCellDisplayData() -> [HomeViewController.Item] {
        guard !state.citiesWeatherInfo.isEmpty else { return State.stubTimeLineItems.toTimelineItems() }
        return getTimeLineItems().toTimelineItems()
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

fileprivate extension TopView.DisplayData {
    init(cityWeatherInfo: CityWeatherInfo) {
        self.cityName = cityWeatherInfo.geoObject.locality.name
        self.currentTemperature = String(cityWeatherInfo.fact.temp!).addDegreeSymbol()
        self.date = "getCurrentDateFormatted()"
        self.temperatureRange = "temperatureRange"
        self.weatherCondition = cityWeatherInfo.fact.condition!
    }

//    private func getCurrentDateFormatted() -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd MMM EEE"
//        let currentDate = Date()
//        let formattedDate = dateFormatter.string(from: currentDate)
//        return formattedDate
//    }
}

fileprivate extension CityCell.DisplayData {
    init(whetherModel: CityWeatherInfo) {
    cityName = whetherModel.geoObject.locality.name
    currentTemperature = String(whetherModel.fact.temp!).addDegreeSymbol()
    }
}

fileprivate extension TimelineCell.DisplayData {
    init(hourWeatherInfo: HourWeatherInfo) {
        self.iconImageData = hourWeatherInfo.iconImageData
        self.temperature = String(hourWeatherInfo.temperature).addDegreeSymbol()
        self.time = hourWeatherInfo.hour.transformedTo12HourFormat()
    }
}
