//
//  AddMarker.swift
//  CarLocation
//
//  Created by Pavel Burdukovskii on 01/06/2018.
//  Copyright © 2018 Pavel Burdukovskii. All rights reserved.
//

import Foundation
import GooglePlaces
import GoogleMaps
class Managers{
    static let shared : Managers = {
        return Managers()
    }()
    private init(){}
    private var carModel : [String : CarModel] = Dictionary()
    //add marker to mapView
    private func showMarker(mapView  : GMSMapView?){
        let lat = (mapView?.camera.target.latitude)!
        let lon = (mapView?.camera.target.longitude)!
        responseCar()
        for car in carModel{
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: car.value.lat + lat, longitude: car.value.lon + lon)
            marker.title = car.value.model
            marker.map = mapView
            
        }
    }
    
    func updateData(mapView : GMSMapView?){
        showMarker(mapView: mapView)
    }

    func getData(key : String)->CarModel{
        return carModel[key]!
    }
    private func responseCar(){
        carModel["Audi"] = (addCar(model: "Audi", photo: "audi", lat: 0.0101, lon: 0.0022))
        carModel["Honda"] = (addCar(model: "Honda", photo: "honda", lat: 0.0012, lon: 0.0027))
        carModel["Toyota"] = (addCar(model: "Toyota", photo: "toyota", lat: 0.0022, lon: 0.0031))
        carModel["Restomod"] = (addCar(model: "Restomod", photo: "restomod", lat: 0.0042, lon: 0.0025))
        carModel["Ford"] = (addCar(model: "Ford", photo: "ford", lat: 0.0054, lon: 0.0019))
    }
    private func addCar(model : String, photo : String, lat: CLLocationDegrees, lon: CLLocationDegrees)->CarModel{
        let car = CarModel(model: model, photo: photo, lat: lat, lon: lon)
        return car
    }
}
