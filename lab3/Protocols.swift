//
//  Protocols.swift
//  lab3
//
//  Created by Admin on 07.03.17.
//  Copyright © 2017 user. All rights reserved.
//

import Foundation

protocol WeatherModelInjectable {
    func setWeatherModel(weatherModel : WeatherModel)
}

protocol WeatherReloadAsyncDelegate {
    func reloadWeather()
    func onError()
}

protocol ShowErrorDelegate {
    func showError()
}
