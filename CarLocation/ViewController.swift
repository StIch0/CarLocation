//
//  ViewController.swift
//  CarLocation
//
//  Created by Pavel Burdukovskii on 01/06/2018.
//  Copyright © 2018 Pavel Burdukovskii. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class ViewController: UIViewController {
    let apiKey  : String = "AIzaSyBu1s1WyxnVMxofslu0CPwci7_Ojnj5LIY"
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    let addMarker = Managers.shared
    var tappedMarker = GMSMarker()
    var infoView : InfoView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    override func viewDidLoad() {
        super.viewDidLoad()
        GMSServices.provideAPIKey(apiKey)
        GMSPlacesClient.provideAPIKey(apiKey)
        let camera = GMSCameraPosition.camera(withTarget: .init(), zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        mapView.settings.myLocationButton = true
        view = mapView
        mapView.addObserver(self, forKeyPath: "myLocation", options: .new, context: nil)
        DispatchQueue.main.async {
            self.mapView.isMyLocationEnabled = true

        }
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.requestAlwaysAuthorization()
        placesClient = GMSPlacesClient.shared()

    }
     
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if change![NSKeyValueChangeKey.oldKey] == nil {
            let location = change![NSKeyValueChangeKey.newKey] as! CLLocation
            mapView.camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: zoomLevel)
                updateData()
        }
       
    }
   @objc func updateData(){
        addMarker.updateData(mapView: mapView)
    }
   
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        mapView.removeObserver(self, forKeyPath: "myLocation")
    }
}
