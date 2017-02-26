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
}

class ViewController: UIViewController, WeatherReloadAsyncDelegate {
    lazy var weatherModel : WeatherModel = WeatherModel(delegate: self)
    @IBOutlet weak var mapView: MKMapView!
    var selectedCityName: String? = nil
    
    internal func reloadWeather() {
        let citiesWeather = weatherModel.weatherCities
        var cities : [CityAnnotation] = [CityAnnotation]()
        for cityWeather in citiesWeather {
            let city = CityAnnotation(coordinate: cityWeather.location.coordinate)
            city.title = cityWeather.cityName
            city.subtitle = cityWeather.temperature
            
            cities.append(city)
        }
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(cities)
        if (selectedCityName != nil) {
            var city:CityAnnotation? = nil
            for _annotation in mapView.annotations {
                if let annotation = _annotation as? CityAnnotation {
                    if annotation.title == selectedCityName {
                        city = annotation
                        break
                    }
                }
            }
            mapView.selectAnnotation(city!, animated: false)
        }
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
                /*let city = City(coordinate: cityWeather.location.coordinate)
                city.title = cityWeather.cityName
                city.subtitle = cityWeather.temperature
                mapObject.removeAnnotations(mapObject.annotations)
                
                mapObject.addAnnotation(city)*/
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
                    selectedCityName = city?.title
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
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(ViewController.startRefreshing), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

