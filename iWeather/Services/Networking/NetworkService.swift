//
//  NetworkService.swift
//  iWeather
//
//  Created by Юрий Степанчук on 09.02.2024.
//

import Foundation

final class NetworkService {
    private enum Constants {
        static let apiKey = "8a080b6e-081a-467d-9e63-7d6972fce56f"
        static let searchEndpoint = "https://api.weather.yandex.ru/v2/forecast?"
        static let HTTPHeaderField = "X-Yandex-API-Key"
    }

    func downloadWeatherInfo(for cities: [PresetCity], completion: @escaping (Result<[CityWeatherInfo], NetworkError>) -> Void) {
        var citiesWeatherInfo: [CityWeatherInfo] = []
        let dispatchGroup = DispatchGroup()

        for city in cities {
            dispatchGroup.enter()

            let (latitude, longitude) = city.coordinates
            downloadWeatherInfoForCityAt(latitude: latitude, longitude: longitude) { result in
                switch result {
                case let .success(weatherInfo): citiesWeatherInfo.append(weatherInfo)
                case let .failure(error): print(error.localizedDescription)
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            self.addWeatherIconsData(to: citiesWeatherInfo) { result in
                completion(result)
            }
        }
    }

    private func downloadWeatherInfoForCityAt(latitude lat: String, longitude lon: String, completion: @escaping (Result<CityWeatherInfo, NetworkError>) -> Void) {
        guard let url = URL(string: Constants.searchEndpoint + "lat=\(lat)&lon=\(lon)&hours=true") else {
            completion(.failure(.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.addValue(Constants.apiKey, forHTTPHeaderField: Constants.HTTPHeaderField)

        fetchData(using: request) { [weak self] dataFetchingResult in
            guard let self else { return }

            switch dataFetchingResult {
            case let .success(data):
                parseWeatherInfo(from: data) { decodingResult in
                    DispatchQueue.main.async {
                        switch decodingResult {
                        case let .success(weatherInfo):
                            completion(.success(weatherInfo))
                        case let .failure(error):
                            completion(.failure(error))
                        }
                    }
                }
            case let .failure(error):
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }
    }

    private func addWeatherIconsData(to citiesWeatherInfo: [CityWeatherInfo], completion: @escaping (Result<[CityWeatherInfo], NetworkError>) -> Void) {
        var updatedCitiesWeatherInfo = citiesWeatherInfo
        let dispatchGroup = DispatchGroup()

        for (cityIndex, city) in citiesWeatherInfo.enumerated() {
            for (hourIndex, hour) in city.forecasts[0].hours.enumerated() {
                let iconImageURLString = "https://yastatic.net/weather/i/icons/funky/dark/\(hour.iconName).svg"
                dispatchGroup.enter()
                downloadImageData(from: iconImageURLString) { result in
                    defer {
                        dispatchGroup.leave()
                    }
                    switch result {
                    case let .success(iconImageData):
                        updatedCitiesWeatherInfo[cityIndex].forecasts[0].hours[hourIndex].iconImageData = iconImageData
                    case let .failure(error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            completion(.success(updatedCitiesWeatherInfo))
        }
    }

    private func downloadImageData(from urlString: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }

        fetchData(from: url) { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(imageData):
                    completion(.success(imageData))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    }

    private func fetchData(using request: URLRequest, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                self.handleNetworkError(error, completion)
            } else {
                self.handleHTTPResponse(response, data, completion)
            }
        }
        dataTask.resume()
    }

    private func fetchData(from url: URL?, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url = url else {
            completion(.failure(.invalidURL))
            return
        }

        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                self.handleNetworkError(error, completion)
            } else {
                self.handleHTTPResponse(response, data, completion)
            }
        }
        dataTask.resume()
    }

    private func handleNetworkError(_ error: Error, _ completion: @escaping (Result<Data, NetworkError>) -> Void) {
        if let error = error as NSError?, error.code == NSURLErrorNotConnectedToInternet {
            completion(.failure(.noInternetConnection))
        } else {
            completion(.failure(.requestFailed))
        }
    }

    private func handleHTTPResponse(_ response: URLResponse?, _ data: Data?, _ completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let httpResponse = response as? HTTPURLResponse else {
            completion(.failure(.noServerResponse))
            return
        }

        switch httpResponse.statusCode {
        case 200:
            if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(.noDataInServerResponse))
            }
        case 403:
            completion(.failure(.forbidden403))
        default:
            completion(.failure(.badResponse(statusCode: httpResponse.statusCode)))
        }
    }

    private func parseWeatherInfo(from data: Data, completion: @escaping (Result<CityWeatherInfo, NetworkError>) -> Void) {
        let decoder = JSONDecoder()
        do {
            let weather = try decoder.decode(CityWeatherInfo.self, from: data)
            completion(.success(weather))
        } catch {
            completion(.failure(NetworkError.decodingFailed))
        }
    }
}
