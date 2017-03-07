//
//  WeatherModel.swift
//  lab3
//
//  Created by Konstantin Terehov on 2/25/17.
//  Copyright © 2017 Konstantin Terehov. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire
import SwiftyJSON

struct WeatherCity {
    var id: Int!
    var cityName: String!
    var temperature: String!
    var location: CLLocation!
}

class WeatherModel {
    private let YAHOO_QUERY = "https://query.yahooapis.com/v1/public/yql?q=select%20item.condition.temp%2C%20item.lat%2C%20wind.direction%2C%20wind.speed%2C%20item.long%2C%20location.city%20from%20weather.forecast%20where%20woeid%20in(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22Minsk%2C%20BY%22%20or%20text%3D%22Dubrovno%2C%20BY%22%20or%20text%3D%22Orsha%2C%20BY%22%20or%20text%3D%22Baran'%2C%20BY%22%20or%20text%3D%22Mahilyow%2C%20BY%22%20or%20text%3D%22Bobruysk%2C%20BY%22%20or%20text%3D%22Osipovichi%2C%20BY%22%20or%20text%3D%22Kopyl'%2C%20BY%22%20or%20text%3D%22Nesvizh%2C%20BY%22%20or%20text%3D%22Mir%2C%20BY%22%20or%20text%3D%22Navahrudak%2C%20BY%22%20or%20text%3D%22Slonim%2C%20BY%22%20or%20text%3D%22Pruzhany%2C%20BY%22%20or%20text%3D%22Brest%2C%20BY%22%20or%20text%3D%22Vileyka%2C%20BY%22%20or%20text%3D%22Pinsk%2C%20BY%22%20or%20text%3D%22Baranavichy%2C%20BY%22%20or%20text%3D%22Navapolatsk%2C%20BY%22%20or%20text%3D%22Vitsyebsk%2C%20BY%22%20or%20text%3D%22Homyel'%2C%20BY%22%20or%20text%3D%22Barysaw%2C%20BY%22)%20and%20u%3D'c'&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="
    
    var weatherCities: [WeatherCity] = [WeatherCity]()
    private var delegates: [WeatherReloadAsyncDelegate] = [WeatherReloadAsyncDelegate]()
    
    public func refresh() {
        Alamofire.request(YAHOO_QUERY).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                self.weatherCities = [WeatherCity]()
                let json = JSON(value)
                let cities = json["query"]["results"]["channel"]
                var index: Int = 0
                for (_,subJson):(String, JSON) in cities {
                    if  let city = subJson["location"]["city"].string,
                        let temperature = subJson["item"]["condition"]["temp"].string,
                        let latitude = subJson["item"]["lat"].string, let longitude = subJson["item"]["long"].string
                    {
                        var tempWeatherCity = WeatherCity()
                        tempWeatherCity.id = index
                        tempWeatherCity.cityName = city
                        tempWeatherCity.temperature = temperature + " °C"
                        tempWeatherCity.location = CLLocation(latitude: Double(latitude)!, longitude: Double(longitude)!)
                        self.weatherCities.append(tempWeatherCity)
                        self.invokeReloadWeather()
                    } else {
                        self.invokeOnError()
                    }
                    index += 1
                }
            case .failure:
                self.invokeOnError()
            }
        }
    }
    
    public func addReloadDelegate(reloadDelegate : WeatherReloadAsyncDelegate) {
        delegates.append(reloadDelegate)
    }
    
    private func invokeReloadWeather() {
        for delegate in delegates {
            DispatchQueue.main.async{
                delegate.reloadWeather()
            }
        }
    }
    
    private func invokeOnError() {
        for delegate in delegates {
            DispatchQueue.main.async {
                delegate.reloadWeather();
            }
        }
    }
    
}
