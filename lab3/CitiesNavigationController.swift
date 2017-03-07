//
//  CitiesNavigationController.swift
//  lab3
//
//  Created by Admin on 07.03.17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

class CitiesNavigationController: UINavigationController, WeatherModelInjectable {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func setWeatherModel(weatherModel: WeatherModel) {
        for viewController in self.childViewControllers {
            if let weatherModelInjectable = viewController as? WeatherModelInjectable {
                weatherModelInjectable.setWeatherModel(weatherModel: weatherModel)
            }
        }
    }
}
