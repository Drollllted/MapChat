//
//  MapViewModel.swift
//  Fit
//
//  Created by Drolllted on 29.08.2025.
//

import Foundation
import CoreLocation
import MapKit
import Combine

final class MapViewModel: NSObject, ObservableObject {
    
    @Published var location: CLLocationCoordinate2D?
    @Published var friends: [User] = []
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6173),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    @Published var isLoading: Bool = false
    @Published var error: Error?
    
    private let locationFirebaseManager: LocationFirebaseManager
    private let locationService: LocationServiceDelegate
    private var cancellables: Set<AnyCancellable> = []
    private var updateTimer: Timer?
    private let userId: String
    
    init(userId: String, locationService: LocationService = LocationService(), firebaseService: LocationFirebaseManager = LocationFirebase(userId: "")) {
        self.userId = userId
        self.locationService = locationService
        self.locationFirebaseManager = firebaseService
        super.init()
    }
    
    //MARK: - Setup upload location
    
    private func setupBuilding() {
        locationService.locationPublished
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription as? any Error
                }
            } receiveValue: { [weak self] location in
                self?.location = location.coordinate
                self?.region.center = location.coordinate
                
            }
            .store(in: &cancellables)
    }
    
    func startTracking() {
        isLoading = true
        locationService.startUpdatingLocation()
        
        locationFirebaseManager.fetchFriends()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription as? any Error
                }
            } receiveValue: { [weak self] friends in
                self?.friends = friends
                self?.isLoading = false
            }
            .store(in: &cancellables)
        
        updateTimer = Timer.scheduledTimer(withTimeInterval: 7, repeats: true, block: { [weak self] _ in
            self?.updateLocationIfNeeded()
        })

    }
    
    func stopTracking() {
        locationService.stopUpdatingLocation()
        updateTimer?.invalidate()
        updateTimer = nil
        locationFirebaseManager.updateOnlineStatus(false)
    }
    
    func updateLocationInFirebase(location: CLLocation) {
        let userLocation = UserLocation(
            coordinate: location.coordinate,
            speed: Int(location.speed),
            course: Int(location.course)
        )
        locationFirebaseManager.updateUserLocation(userLocation)
    }
    
    private func updateLocationIfNeeded() {
        if let location = location {
            let clLocation = CLLocation(
                latitude: location.latitude,
                longitude: location.longitude
            )
            updateLocationInFirebase(location: clLocation)
        }
    }
    
    func refreshFriends() {
        isLoading = true
        locationFirebaseManager.fetchFriends()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription as? any Error
                }
            } receiveValue: { [weak self] friends in
                self?.friends = friends
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    deinit {
        stopTracking()
    }
    
    
}
