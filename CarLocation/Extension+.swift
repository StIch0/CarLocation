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
import Alamofire
import SwiftyJSON
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
        //mapView.clear()
        let marker = GMSMarker(position: tappedMarker.position)
        marker.title = tappedMarker.title
        marker.map = mapView
        tappedMarker = marker
        getAddres(marker: tappedMarker, currentAdd: {
            returnAddres in
            print(" MyAddres = \(returnAddres)")
        })
        let origin = "\(mapView.myLocation?.coordinate.latitude ?? 0),\(mapView.myLocation?.coordinate.longitude ?? 0)"
        let destination = "\(tappedMarker.position.latitude),\(tappedMarker.position.longitude)"
        let parameters = [
            "origin":origin as AnyObject,
            "destination": destination as AnyObject,
            "mode":"walking"  as AnyObject,
            "alternatives" :"\(true)"  as AnyObject,
            "key": apiKey as AnyObject]
        self.viewModel.getRoutes(parameters: parameters, complete: {
            self.routesModelList = self.viewModel.routesList
            print(self.viewModel.numberOfRoutes())

        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            for i in 0...self.routesModelList.count-1{
                let routeOverViewPolyline = self.routesModelList[i].overViewPolyline
                let path = GMSPath(fromEncodedPath: (routeOverViewPolyline?.points)!)
                let polyline = GMSPolyline(path: path)
                polyline.strokeWidth = 2
                polyline.strokeColor = self.colors[i]
                polyline.map = self.mapView
            }
        })
        
//        addMarker.getRoutes(method: .get, parameters: [
//            "origin":origin as AnyObject ,
//            "destination": destination as AnyObject,
//            "mode":"walking"  as AnyObject,
//            "alternatives" :true  as AnyObject,
//            "key": apiKey as AnyObject], completion: {
//                data in
//                print(data)
//        })
       // let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=walking&alternatives=\(true)&key=AIzaSyCGGX2kVq7G3tcA0_SRK1-tiXC64kBtFag"
//        Alamofire.request(url).responseJSON{
//            responseJson in
//            switch responseJson.result {
//            case .success(let value):
//                let json = JSON(value)
//                let routes = json["routes"].arrayValue
//                for i in 0...routes.count-1 {
//                    let legs = routes[i]["legs"].arrayObject as! [[String : AnyObject]]
//                    let duration = legs.first!["duration"] as! [[String : AnyObject]]
//                    print("duration = \(duration)")
//                    let routeReviewPolyLine = routes[i]["overview_polyline"].dictionary
//                    let points = routeReviewPolyLine?["points"]?.stringValue
//                    let path = GMSPath(fromEncodedPath: points ?? "")
//                    let polyLine = GMSPolyline(path: path)
//                    polyLine.strokeColor = self.colors[i]
//                    polyLine.strokeWidth = 2
//                    polyLine.map = self.mapView
//                }
//            case .failure(let error):
//                print("Error = \(error.localizedDescription)")
//            }
//        }
//        gmsMutablePath.add(tappedMarker.position)
//        let path = GMSPath(fromEncodedPath: "anzbFzeygVaBC?i@WIm@We@g@[i@Oc@Ig@Gs@?_@a@?Ds@Lw@d@gANWGK")
//        let polyLine : GMSPolyline = GMSPolyline()
//        polyLine.path = path
////
//        polyLine.strokeWidth = 2
//        polyLine.strokeColor = .red
//        polyLine.geodesic = true
//        polyLine.map = mapView
    }
    
    private func getAddres(marker : GMSMarker , currentAdd : @escaping ( _ returnAddres : String)->Void){
        geoCoder = GMSGeocoder()
        let coordinate =  marker.position
        var currentAddres : String = ""
        geoCoder.reverseGeocodeCoordinate(coordinate) {
            response , error in
            if let addres = response?.firstResult(){
                let lines = addres.lines! as [String]
                currentAddres = lines.joined(separator: "\n")
                currentAdd(currentAddres)
            }
            else {
                print("Error = \(error?.localizedDescription ?? "") ")
            }
        }
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

