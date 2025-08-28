//
//  SignInViewModel.swift
//  Fit
//
//  Created by Drolllted on 28.08.2025.
//

import Foundation

final class SignInViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    private let firebase = FirebaseService.shared
    
    func signIn() {
        guard !email.isEmpty, !password.isEmpty else {
            print(URLError(.networkConnectionLost))
            return
        }
        Task {
            do {
                let user = try await firebase.signIn(email: email, password: password)
                print("Success sign In")
                print(user)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}
