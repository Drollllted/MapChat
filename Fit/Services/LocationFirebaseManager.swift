//
//  LocationFirebaseManager.swift
//  Fit
//
//  Created by Drolllted on 29.08.2025.
//

import Foundation
import Firebase
import FirebaseFirestore
import Combine

protocol LocationFirebaseManager {
    func updateUserLocation(_ location: User) 
}
