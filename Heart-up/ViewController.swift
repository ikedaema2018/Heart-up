//
//  ViewController.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/08/21.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var lngLabel: UILabel!
    
    var latitude: String!
    var longitude: String!
    var locationManager : CLLocationManager?
    
    @IBOutlet weak var mapView: MKMapView!
    
    
//    @IBAction func tapStopButton(_ sender: UIButton) {
//        guard let manager = locationManager else { return }
//        manager.stopUpdatingLocation()
//        manager.delegate = nil
//        locationManager = nil
//        latLabel.text = "latitude: "
//        lngLabel.text = "longitude: "
//
//        // untracking user location
//        mapView.userTrackingMode = MKUserTrackingMode.none
//        mapView.showsUserLocation = false
//        mapView.removeAnnotations(mapView.annotations)
//    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways, .authorizedWhenInUse:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else {
            return
        }
        
        let location:CLLocationCoordinate2D
            = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude)
        latitude = "".appendingFormat("%.4f", location.latitude)
        longitude = "".appendingFormat("%.4f", location.longitude)
        latLabel.text = "latitude: " + latitude
        lngLabel.text = "longitude: " + longitude
        
        // update annotation
//        mapView.removeAnnotations(mapView.annotations)
//
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = newLocation.coordinate
//        mapView.addAnnotation(annotation)
//        mapView.selectAnnotation(annotation, animated: true)
        
        // Showing annotation zooms the map automatically.
//        mapView.showAnnotations(mapView.annotations, animated: true)
        
    }
    
    @IBAction func locatePost(_ sender: Any) {
        if let latitude_p = latitude, let longitude_p = longitude {
            let locate = LocateInfo()
            locate.ido = latitude_p
            locate.keido = longitude_p
            StockLocateInfos.postLocate(locate: locate)
            print("testtest")
        }
    }
    
    @IBAction func test(_ sender: UIButton) {
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if locationManager != nil { return }
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        locationManager!.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager!.startUpdatingLocation()
        }
        // tracking user location
        mapView.userTrackingMode = MKUserTrackingMode.followWithHeading
        mapView.showsUserLocation = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

