//
//  ViewController.swift
//  lab3
//
//  Created by Konstantin Terehov on 2/20/17.
//  Copyright © 2017 Konstantin Terehov. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class CityAnnotation: NSObject, MKAnnotation {
    var id: Int?
    var title: String?
    var subtitle: String?
    var latitude: Double
    var longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    init(coordinate: CLLocationCoordinate2D) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }
}

protocol WeatherReloadAsyncDelegate {
    func reloadWeather()
    func onError()
}

class MapViewController: UIViewController, WeatherReloadAsyncDelegate {
    lazy var weatherModel : WeatherModel = WeatherModel(delegate: self)
    let alertController = UIAlertController(title: "Error", message: "Can't get weather info", preferredStyle: .alert)
    
    @IBOutlet weak var mapView: MKMapView!
    
    internal func reloadWeather() {
        let citiesWeather = weatherModel.weatherCities
        for cityWeather in citiesWeather {
            var city : CityAnnotation? = nil
            for _annotation in mapView.annotations {
                if let annotation = _annotation as? CityAnnotation {
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
    
    internal func onError() {
        present(alertController, animated: true, completion: nil)
    }
    
    func startRefreshing() {
        weatherModel.refresh()
    }

    @IBAction func longPressMap(_ sender: Any) {
        let longTap = sender as! UILongPressGestureRecognizer
        if (longTap.state == .ended) {
            let location_point = longTap.location(in: mapView)
            let location = mapView.convert(location_point, toCoordinateFrom: mapView)
            let cllocation = CLLocation(latitude:location.latitude, longitude:location.longitude)
            let citiesWeather = weatherModel.weatherCities
        
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
        weatherModel.refresh()
        Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(MapViewController.startRefreshing), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

