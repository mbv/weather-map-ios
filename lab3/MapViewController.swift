//
//  ViewController.swift
//  lab3
//
//  Created by user on 2/20/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, WeatherReloadAsyncDelegate, WeatherModelInjectable {
    var weatherModel : WeatherModel?
    private let alertController = UIAlertController(title: "Error", message: "Can't get weather info", preferredStyle: .alert)
    
    @IBOutlet weak var mapView: MKMapView!
    
    internal func reloadWeather() {
        if mapView != nil {
            let citiesWeather = weatherModel!.weatherCities
            for cityWeather in citiesWeather {
                var city : CityAnnotation? = nil
                for currentAnnotation in mapView.annotations {
                    if let annotation = currentAnnotation as? CityAnnotation {
                        if annotation.id == cityWeather.id {
                            city = annotation
                            break
                        }
                    }
                }
                if city != nil {
                    city?.subtitle = cityWeather.temperature
                } else {
                    let city = CityAnnotation(coordinate: cityWeather.location.coordinate)
                    city.id = cityWeather.id
                    city.title = cityWeather.cityName
                    city.subtitle = cityWeather.temperature
                    mapView.addAnnotation(city)
                }
            }
        }
    }
        
    
    internal func onError() {
        
    }
    
    func startRefreshing() {
        weatherModel!.refresh()
    }

    @IBAction func longPressMap(_ sender: Any) {
        let longTap = sender as! UILongPressGestureRecognizer
        if (longTap.state == .began) {
            let location_point = longTap.location(in: mapView)
            let location = mapView.convert(location_point, toCoordinateFrom: mapView)
            let cllocation = CLLocation(latitude:location.latitude, longitude:location.longitude)
            let citiesWeather = weatherModel!.weatherCities
        
            var nearestCity: WeatherCity? = nil
            var nearestCityDistance:CLLocationDistance?
            for cityWeather in citiesWeather {
                let distance = cllocation.distance(from: cityWeather.location)
                if nearestCityDistance == nil || distance < nearestCityDistance! {
                    nearestCity = cityWeather
                    nearestCityDistance = distance
                }
            }
            if nearestCity != nil {
                let cityWeather = nearestCity!
                var city:CityAnnotation? = nil
                for _annotation in mapView.annotations {
                    if let annotation = _annotation as? CityAnnotation {
                        if annotation.title == cityWeather.cityName {
                            city = annotation
                            break
                        }
                    }
                }
                
                if city != nil {
                    showCityOnMap(city: city!)
                }
                
            }
        }
    }
    
    func showCityOnMap(city: CityAnnotation) {
        mapView.selectAnnotation(city, animated: true)
        
        let region = MKCoordinateRegionMake(city.coordinate, MKCoordinateSpanMake(1, 1))
        
        mapView.setRegion(region, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setActionForAlertController();
        weatherModel!.refresh()
        Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(MapViewController.startRefreshing), userInfo: nil, repeats: true)
    }
    
    private func setActionForAlertController() {
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
    }

    func setWeatherModel(weatherModel: WeatherModel) {
        self.weatherModel = weatherModel
        weatherModel.addReloadDelegate(reloadDelegate: self)
    }

}

