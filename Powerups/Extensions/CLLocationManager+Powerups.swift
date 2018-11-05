//
//  CLLocationManager.swift
//  BlinkDemo
//
//  Created by Sean Orelli on 8/28/18.
//  Copyright © 2018 Fuzz. All rights reserved.
//
import UIKit
import CoreLocation

typealias ClosureWithLocations = ( [CLLocation] ) -> Void
typealias ClosureWithBeacons = ( [CLBeacon] ) -> Void
typealias ClosureWithBeaconsAndRegion = ( [CLBeacon], CLBeaconRegion ) -> Void
/*______________________________________________________

			Core Location Manager Delegate
______________________________________________________*/
extension CLLocationManager: CLLocationManagerDelegate {

	static var shared: CLLocationManager?
	static var inRegion = false
	static func setupLocationManager() -> CLLocationManager {
		let l = CLLocationManager()
		l.delegate = l
		l.desiredAccuracy = kCLLocationAccuracyBest
		l.distanceFilter = 100
		l.allowsBackgroundLocationUpdates = true
		shared = l
		return l
	}

	static func requestAuth(){
		if (CLLocationManager.locationServicesEnabled()) {
			CLLocationManager.shared?.requestAlwaysAuthorization()
			CLLocationManager.shared?.requestWhenInUseAuthorization()
		}
	}

	var didChangeLocation: ClosureWithLocations? {
		get{ return associatedObjects["didChangeLocation"] as? ClosureWithLocations }
		set(l){ associatedObjects["didChangeLocation"] = l; self.delegate = self }
	}

	var didRangeBeacons: ClosureWithBeaconsAndRegion? {
		get{ return associatedObjects["didRangeBeacons"] as? ClosureWithBeaconsAndRegion }
		set(l){ associatedObjects["didRangeBeacons"] = l; self.delegate = self }
	}

	public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

		for r in manager.monitoredRegions {

			if let cr = r as? CLCircularRegion {
				//print(cr.identifier)
				if cr.contains(locations[0].coordinate) {
					//print("Am in the region!")

					if CLLocationManager.inRegion == false {
//						"Enter Region_".sendLocalNotification()
//						"Enter Region_".alert()
					}
					CLLocationManager.inRegion = true
				} else {
					let crLoc = CLLocation(latitude: cr.center.latitude, longitude: cr.center.longitude)
					print("distance is: \(locations[0].distance(from: crLoc))")
					if CLLocationManager.inRegion {
//						"Exit Region_".sendLocalNotification()
//						"Exit Region_".alert()
					}
					CLLocationManager.inRegion = false
				}
			}
		}


		if let closure = didChangeLocation {
			closure(locations)
		}
	}

	public func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
		//"Monitoring did Fail".alert()
		//"Monitoring did Fail".sendLocalNotification()
	}

	public func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
		//"Did Start Monitoring \(region.identifier)".sendLocalNotification()
		manager.requestState(for: region)

	}

	public func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {


    	if state == .inside {
			//print("Inside \(region.identifier)")//.sendLocalNotification()
    	}

		if state == .outside {
			//print("Outside \(region.identifier)")//.sendLocalNotification()
    	}

	}

	public func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
		//UIAlertController.alert(title: "Did Enter region")
		//"Did Enter Region \(region.identifier)".sendLocalNotification()
	}

	public func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
		//UIAlertController.alert(title: "Did Exit region")
		//"Did Exit Region \(region.identifier)".sendLocalNotification()
	}

	public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

    	if status == .authorizedAlways {
        	if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
            	if CLLocationManager.isRangingAvailable() {
					print("beacon ranging available")
            	}
        	}
    	}
	}

	public func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
		didRangeBeacons?(beacons, region)
	}


	func scanForBeacons(_ beacons: [CLBeaconRegion]) {
		beacons.forEach { (region) in
			startMonitoring(for: region)
			startRangingBeacons(in: region)
		}
	}

	func stopScanForBeacons(_ beacons: [CLBeaconRegion]) {
		beacons.forEach { (region) in
			stopMonitoring(for: region)
			stopRangingBeacons(in: region)
		}
	}
}
