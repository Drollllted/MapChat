//
//  SignUpViewModel.swift
//  Fit
//
//  Created by Drolllted on 28.08.2025.
//

import Foundation

final class SignUpViewModel: ObservableObject {
    
    //регистрация нового пользователя
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var fullName: String = ""
    @Published var confirmPassword: String = ""
    
    func setupNewUser() {
        guard !email.isEmpty, !password.isEmpty else {
            return
        }
        Task {
            do {
                let newuser = try await FirebaseService.shared.createUser(email: email, password: password)
                print("All Right")
                print(newuser)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}
