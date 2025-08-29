//
//  FirebaseSerivce.swift
//  Fit
//
//  Created by Drolllted on 28.08.2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine

protocol AuthServiceProtocol {
    var currentUser: AuthUser? { get }
    var authStatePublisher: AnyPublisher<AuthUser?, Never> { get }
    
    func signUp(email: String, password: String, name: String) async throws -> AuthUser
    func signIn(email: String, password: String) async throws -> AuthUser
    func signOut() throws
    func resetPassword(email: String) async throws
    func updateEmail(email: String) async throws
    func updatePassword(password: String) async throws
}

class AuthService: AuthServiceProtocol {
    static let shared = AuthService()
    
    private let auth = Auth.auth()
    private let firestore = Firestore.firestore()
    private let authStateSubject = PassthroughSubject<AuthUser?, Never>()
    
    var currentUser: AuthUser? {
        guard let user = auth.currentUser else { return nil }
        return AuthUser(user: user)
    }
    
    var authStatePublisher: AnyPublisher<AuthUser?, Never> {
        authStateSubject.eraseToAnyPublisher()
    }
    
    private init() {
        setupAuthStateListener()
    }
    
    private func setupAuthStateListener() {
        auth.addStateDidChangeListener { [weak self] _, firebaseUser in
            let authUser = firebaseUser.map { AuthUser(user: $0) }
            self?.authStateSubject.send(authUser)
        }
    }
    
    // MARK: - Sign Up
    func signUp(email: String, password: String, name: String) async throws -> AuthUser {
        let authResult = try await auth.createUser(withEmail: email, password: password)
        let authUser = AuthUser(user: authResult.user)
        
        // Создаем запись пользователя в Firestore
        try await createUserInFirestore(authUser: authUser, name: name)
        
        return authUser
    }
    
    private func createUserInFirestore(authUser: AuthUser, name: String) async throws {
        let userData: [String: Any] = [
            "id": authUser.uid,
            "email": authUser.email ?? "",
            "name": name,
            "isOnline": false,
            "lastSeen": FieldValue.serverTimestamp(),
            "createdAt": FieldValue.serverTimestamp()
        ]
        
        try await firestore.collection("users").document(authUser.uid).setData(userData)
    }
    
    // MARK: - Sign In
    func signIn(email: String, password: String) async throws -> AuthUser {
        let authResult = try await auth.signIn(withEmail: email, password: password)
        return AuthUser(user: authResult.user)
    }
    
    // MARK: - Sign Out
    func signOut() throws {
        try auth.signOut()
    }
    
    // MARK: - Reset Password
    func resetPassword(email: String) async throws {
        try await auth.sendPasswordReset(withEmail: email)
    }
    
    // MARK: - Update Email
    func updateEmail(email: String) async throws {
        guard let firebaseUser = auth.currentUser else {
            throw NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No authenticated user"])
        }
        try await firebaseUser.sendEmailVerification(beforeUpdatingEmail: email)
    }
    
    // MARK: - Update Password
    func updatePassword(password: String) async throws {
        guard let firebaseUser = auth.currentUser else {
            throw NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No authenticated user"])
        }
        try await firebaseUser.updatePassword(to: password)
    }
}
