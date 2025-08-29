//
//  SignInModel.swift
//  Fit
//
//  Created by Drolllted on 28.08.2025.
//

import Foundation
import CoreLocation
import FirebaseAuth

//MARK: - For Auth

struct AuthUser: Codable{
    let uid: String
    let email: String?
    let isEmailVerified: Bool
    
    init(user: FirebaseAuth.User) {
        self.uid = user.uid
        self.email = user.email
        self.isEmailVerified = user.isEmailVerified
    }
}


// MARK: - Location

struct User: Codable {
    let id: String
    let email: String
    let name: String
    var location: UserLocation?
    var isOnline: Bool
    var lastSeen: Date
    let userVerifire: Bool
    
    init(authUser: AuthUser, name: String) {
        self.id = authUser.uid
        self.email = authUser.email ?? ""
        self.name = name
        self.isOnline = false
        self.lastSeen = Date()
        self.location = nil
        self.userVerifire = authUser.isEmailVerified
    }
    
}

struct UserLocation: Codable {
    let latitude: Double
    let longitude: Double
    let timestamp: Date
    let speed: Int
    let course: Int
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(coordinate: CLLocationCoordinate2D, speed: Int, course: Int) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
        self.speed = speed
        self.course = course
        self.timestamp = Date()
    }
}
