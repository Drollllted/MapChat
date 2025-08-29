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
    func updateUserLocation(_ location: UserLocation)
    func fetchFriends() -> AnyPublisher<[User], Error>
    func listenForFriendUpdates() -> AnyPublisher<User, Error>
    func updateOnlineStatus(_ isOnline: Bool)
}

final class LocationFirebase: LocationFirebaseManager {
    
    private let db = Firestore.firestore()
    private let userId: String
    
    init(userId: String) {
        self.userId = userId
    }
    
    //MARK: - Update Location for User
    
    func updateUserLocation(_ location: UserLocation) {
        guard let locationData = try? Firestore.Encoder().encode(location) else {return}
        
        db.collection("users").document(userId).updateData([
            "location" : locationData,
            "lastSeen" : FieldValue.serverTimestamp(),
            "isOnline" : true
        ])
    }
    
    //MARK: - Fetch Friends
    
    func fetchFriends() -> AnyPublisher<[User], any Error> {
        Future<[User], Error> { promise in
            self.db.collection("users")
                .whereField("isOnline", isEqualTo: true)
                .getDocuments { snapshot, error in
                    if let error = error {
                        promise(.failure(error.localizedDescription as! Error))
                        return
                    }
                    let users = snapshot?.documents.compactMap { document -> User? in
                        try? document.data(as: User.self)
                    }.filter { $0.id != self.userId } ?? []
                    
                    promise(.success(users))
                }
        }
        .eraseToAnyPublisher()
    }
    
    //MARK: - Change updates
    
    func listenForFriendUpdates() -> AnyPublisher<User, Error> {
        PassthroughSubject<User, Error>().eraseToAnyPublisher()
        
        return Future<User, Error> { promise in
            self.db.collection("users")
                .whereField("isOnline", isEqualTo: true)
                .addSnapshotListener { snapshot, error in
                    
                }
        }
        .eraseToAnyPublisher()
    }
    
    //MARK: - Updates Status
    
    func updateOnlineStatus(_ isOnline: Bool) {
        db.collection("users").document(userId).updateData([
            "isOnline" : true,
            "lastSeen" : FieldValue.serverTimestamp()
        ])
    }
    
    
}
