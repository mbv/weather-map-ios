//
//  RootViewController.swift
//  lab3
//
//  Created by Admin on 07.03.17.
//  Copyright © 2017 Konstantin Terehov. All rights reserved.
//

import UIKit

protocol WeatherModelInjectable {
    func setWeatherModel(weatherModel : WeatherModel)
}

class RootViewController: UITabBarController {

    let weatherModel : WeatherModel = WeatherModel()
    
    override func viewDidLoad() {
        injectWeatherModel()
        super.viewDidLoad()
    }
    
    private func injectWeatherModel() {
        for viewController in self.childViewControllers {
            if let weatherModelInjectable = viewController as? WeatherModelInjectable {
                weatherModelInjectable.setWeatherModel(weatherModel: weatherModel)
            }
        }
    }
}
