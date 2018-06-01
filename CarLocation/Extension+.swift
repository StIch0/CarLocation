//
//  Extension+.swift
//  CarLocation
//
//  Created by Pavel Burdukovskii on 01/06/2018.
//  Copyright © 2018 Pavel Burdukovskii. All rights reserved.
//

import Foundation
import GoogleMaps
import GooglePlaces
extension ViewController : GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        return UIView()
    }
    //add subview and markers var on view
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
         let location = CLLocationCoordinate2D(latitude: marker.position.latitude, longitude: marker.position.longitude)
        tappedMarker = marker
        if infoView != nil {
            infoView.removeFromSuperview()
        }
        infoView = InfoView.init(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        let car = addMarker.getData(key: tappedMarker.title!)
        infoView.modelLabel.text = car.model
        infoView.photo.image = UIImage(named : car.photo)
        infoView.backgroundColor = UIColor.white
        infoView.layer.cornerRadius = 6
        infoView.modelLabel.textAlignment = .center
        infoView.buttonChoose.setTitle("Выбрать", for:  .normal)
        infoView.buttonChoose.backgroundColor = .lightGray
        infoView.buttonChoose.layer.borderWidth = 2
        infoView.buttonChoose.layer.borderColor = UIColor.black.cgColor
        infoView.buttonChoose.titleLabel?.textColor = .white
        infoView.center = mapView.projection.point(for: location)
        infoView.buttonChoose.addTarget(self, action: #selector(tapToButton), for: .touchUpInside)
        self.view.addSubview(infoView)
        return false
    }
    //move subview to camera poasition
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        if (tappedMarker.userData != nil){
            let location = CLLocationCoordinate2D(latitude: tappedMarker.position.latitude, longitude: tappedMarker.position.longitude)
            infoView.center = mapView.projection.point(for: location)
        }
    }
    //hide subview
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        infoView.removeFromSuperview()
    }
    //tap to button Выбрать
    @objc func tapToButton(){
        infoView.removeFromSuperview()        
        mapView.clear()
        let marker = GMSMarker(position: tappedMarker.position)
        marker.title = tappedMarker.title
        marker.map = mapView
        tappedMarker = marker
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)
    }
}
extension ViewController : CLLocationManagerDelegate{
    //get current position
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
    }
    //allowed to get position
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Доступ к местоположению ограничен")
        case .denied:
            print("Нет доступа к местоположению")
            mapView.isHidden = false
        case .notDetermined:
            print("Местоположение не определено")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Доступ получен")
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}
