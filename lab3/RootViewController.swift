//
//  RootViewController.swift
//  lab3
//
//  Created by Admin on 07.03.17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

class RootViewController: UITabBarController, ShowErrorDelegate {

    let weatherModel : WeatherModel = WeatherModel()
    let alertController = UIAlertController(title: "Error", message: "Can't get weather info", preferredStyle: .alert)

    
    override func viewDidLoad() {
        setActionForAlertController()
        weatherModel.setErrorDelegate(errorDelegate: self)
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
    
    private func setActionForAlertController() {
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
    }
    
    func showError() {
        present(alertController, animated: true, completion: nil)
    }
}
