//
//  LocationService.swift
//  Fit
//
//  Created by Drolllted on 29.08.2025.
//

import Foundation
import CoreLocation
import Combine

protocol LocationServiceDelegate {
    var locationPublished: AnyPublisher<CLLocation, Error> {get}
    func startUpdatingLocation()
    func stopUpdatingLocation()
}

final class LocationService: NSObject, LocationServiceDelegate {
    
    static let shared = LocationService()
    private let locationManager = CLLocationManager()
    private let locationSubject = PassthroughSubject <CLLocation, Error>()
    
    var locationPublished: AnyPublisher<CLLocation, any Error> {
        locationSubject.eraseToAnyPublisher()
    }
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.distanceFilter = 10
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func startUpdatingLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
}

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        locationSubject.send(location)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        locationSubject.send(completion: .failure(error.localizedDescription as! Error))
    }
    
}
