//
//  DetailWeatherViewController.swift
//  lab3
//
//  Created by Konstantin Terehov on 2/26/17.
//  Copyright © 2017 Konstantin Terehov. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DetailWeatherViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var cityInfo: CityAnnotation? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        if cityInfo != nil {
            let city = cityInfo!
            mapView.addAnnotation(city)
            mapView.selectAnnotation(city, animated: true)
            
            let region = MKCoordinateRegionMake(city.coordinate, MKCoordinateSpanMake(1, 1))
            
            mapView.setRegion(region, animated: true)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
