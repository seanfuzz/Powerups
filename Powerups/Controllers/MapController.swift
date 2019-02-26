//
//  MapController.swift
//  Powerups
//
//  Created by Sean Orelli on 12/7/18.
//  Copyright © 2018 Sean Orelli. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol MapAnnotationProvider {
    func annotationView(map:MKMapView) -> MKAnnotationView?
}

class MapAnnotation: MKAnnotationView {

    func setup() {
        
    }
}


class MapItem: NSObject, MapAnnotationProvider {
    
    let identifier = "\(MKAnnotationView.self)"
    var title = "Item"
    var selectedClosure: Block = {}
    var latitude: Double = 0
    var longitude: Double = 0
    var coordinates: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        }
        set(c) {
            latitude = Double(c.latitude)
            longitude = Double(c.latitude)
        }
    }

    func annotationView(map:MKMapView) -> MKAnnotationView? {
        if let view = map.dequeueReusableAnnotationView(withIdentifier: identifier){
            return view
        }
        return nil
    }
    
    
}


class MapController: ViewController, MKMapViewDelegate {
    
    let mapView = MKMapView()

    //let items = [MapItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)
        mapView.pin()
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: "\(MKAnnotationView.self)")
        addAnnotations()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        CLLocationManager.requestAuth()
    }
    
    func mapView( _ mapView: MKMapView, didUpdate userLocation: MKUserLocation )
    {
        //let regionRadius = 400 // in meters
        let span = MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 20)
        let coordinateRegion = MKCoordinateRegion(center: userLocation.coordinate, span: span)
        self.mapView.setRegion( coordinateRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        /*
        if let view = mapView.dequeueReusableAnnotationView(withIdentifier: "\(MKAnnotationView.self)"){
            view.backgroundColor = .purple
            view.frame = CGRect(x: 0, y: 0, width: 128, height: 128)
            return view
            
        }*/
        
        return nil
    }
    
    public func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("selected")
        
    }
    
    func addAnnotations(){
        let points = [
            ["title": "New York, NY",    "latitude": 40.713054, "longitude": -74.007228],
            ["title": "Los Angeles, CA", "latitude": 34.052238, "longitude": -118.243344],
            ["title": "Chicago, IL",     "latitude": 41.883229, "longitude": -87.632398]
        ]
        for point in points {
            let annotation = MKPointAnnotation()
            annotation.title = point["title"] as? String
            annotation.coordinate = CLLocationCoordinate2D(latitude: point["latitude"] as! Double, longitude: point["longitude"] as! Double)
            mapView.addAnnotation(annotation)
        }
    }
}
