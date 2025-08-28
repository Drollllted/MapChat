//
//  FirebaseSerivce.swift
//  Fit
//
//  Created by Drolllted on 28.08.2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class FirebaseSerivce: ObservableObject {
    
    private let auth = Auth.auth()
    private let firestore = Firestore.firestore()
    
    //MARK: - Sign Up
    
    func createUser(email: String, password: String) async {
        do {
            let authUser = try await auth.createUser(withEmail: email, password: password)
            await storeUserFirebaseStorage(uid: authUser.user.uid, email: email, fullName: password)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func storeUserFirebaseStorage(uid: String, email: String, fullName: String) async {
        let user = User(uid: uid, email: email, fullName: fullName)
        do {
            try firestore.collection("users").document(uid).setData(from: user)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //MARK: - Sign In
    
}
