//
//  CityTableViewController.swift
//  lab3
//
//  Created by Konstantin Terehov on 2/26/17.
//  Copyright © 2017 Konstantin Terehov. All rights reserved.
//

import UIKit

class CityTableViewController: UITableViewController, WeatherReloadAsyncDelegate  {
    lazy var weatherModel : WeatherModel = WeatherModel(delegate: self)
    let alertController = UIAlertController(title: "Error", message: "Can't get weather info", preferredStyle: .alert)

    internal func reloadWeather() {
        self.tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    internal func onError() {
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherModel.refresh()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(CityTableViewController.startRefresh), for: UIControlEvents.valueChanged)
    }
    
    func startRefresh() {
        weatherModel.refresh()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherModel.weatherCities.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityWeatherCell", for: indexPath)
        let cityWeather = weatherModel.weatherCities[indexPath.row]
        cell.textLabel?.text = cityWeather.cityName
        cell.detailTextLabel?.text = cityWeather.temperature

        return cell
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueShowDetailWeather") {
            let detailViewController = segue.destination as! DetailWeatherViewController
            let cityWeather = weatherModel.weatherCities[(self.tableView.indexPathForSelectedRow?.row)!]
            let city = CityAnnotation(coordinate: cityWeather.location.coordinate)
            city.title = cityWeather.cityName
            city.subtitle = cityWeather.temperature
            detailViewController.cityInfo = city
        }
    }
 

}
