//
//  FirebaseSerivce.swift
//  Fit
//
//  Created by Drolllted on 28.08.2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class FirebaseService: ObservableObject {
    
    private let auth = Auth.auth()
    private let firestore = Firestore.firestore()
    
    //MARK: - Sign Up
    
    func createUser(email: String, password: String) async throws -> FirebaseModel {
        let authUser = try await auth.createUser(withEmail: email, password: password)
        return FirebaseModel(user: authUser.user)
    }
    
    //MARK: - Get Auth User
    
    func getAuthUser() throws -> FirebaseModel {
        guard let user = auth.currentUser else {
            throw URLError(.badURL)
        }
        
        return FirebaseModel(user: user)
        
    }
    
    //MARK: - Sign In
    
    func signIn(email: String, password: String) async throws -> FirebaseModel {
        let signInUser = try await auth.signIn(withEmail: email, password: password)
        return FirebaseModel(user: signInUser.user)
    }
    
    //MARK: - Reset Password
    
    func resetPassword(password: String) throws {
        guard let user = auth.currentUser else {
            throw URLError(.badServerResponse)
        }
        user.updatePassword(to: password)
    }
    
    //MARK: - Update Email
    
    func resetEmail(email: String) throws {
        guard let user = auth.currentUser else {
            throw URLError(.unknown)
        }
        user.sendEmailVerification(beforeUpdatingEmail: email)
    }
    
    //MARK: - Sign Out
    
    func signOut() throws {
        try auth.signOut()
    }
    
    
}
