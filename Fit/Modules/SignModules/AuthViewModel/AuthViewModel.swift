//
//  AuthViewModel.swift
//  Fit
//
//  Created by Drolllted on 29.08.2025.
//

import Foundation
import Combine

final class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var name = ""
    @Published var confirmPassword = ""
    @Published var isLoading = false
    @Published var error: String?
    @Published var isAuthenticated = false
    @Published var currentUser: AuthUser? // Изменено на AuthUser
    
    private let authService: AuthServiceProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    init(authService: AuthServiceProtocol = AuthService.shared) {
        self.authService = authService
        
    }
    
    private func setupAuthListener() {
        authService.authStatePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                self?.currentUser = user
                self?.isAuthenticated = user != nil
            }
            .store(in: &cancellables)
    }
    
    func signUp() {
        guard validateSignUp() else {return}
        isLoading = true
        error = nil
        
        Task { @MainActor in
            do {
                let user = try await authService.signUp(
                    email: email,
                    password: password,
                    name: name
                )
                self.isLoading = false
                self.isAuthenticated = true
                self.currentUser = user
            } catch {
                self.isLoading = false
                self.error = error.localizedDescription
            }
        }
    }
    
    func signIn() {
        guard validateSignIn() else {return}
        isLoading = true
        error = nil
        
        Task { @MainActor in
            do {
                let user = try await authService.signIn(
                    email: email,
                    password: password
                )
                self.isLoading = false
                self.isAuthenticated = true
                self.currentUser = user
            } catch {
                self.isLoading = false
                self.error = error.localizedDescription
            }
        }
    }
    
    func signOut() {
        do {
            try authService.signOut()
        } catch {
            self.error = error.localizedDescription
        }
    }
    
    //MARK: Validate
    
    private func validateSignUp() -> Bool {
        // Проверка на пустые поля
        guard !email.isEmpty, !password.isEmpty, !name.isEmpty, !confirmPassword.isEmpty else {
            error = "Please fill in all fields"
            return false
        }
        
        // Проверка email на валидность
        guard isValidEmail(email) else {
            error = "Please enter a valid email address"
            return false
        }
        
        // Проверка совпадения паролей
        guard password == confirmPassword else {
            error = "Passwords don't match"
            return false
        }
        
        // Проверка длины пароля
        guard password.count >= 6 else {
            error = "Password must be at least 6 characters"
            return false
        }
        
        // Проверка имени
        guard name.count >= 2 else {
            error = "Name must be at least 2 characters"
            return false
        }
        
        guard name.count <= 50 else {
            error = "Name is too long"
            return false
        }
        
        // Проверка на специальные символы в имени (опционально)
        
        let nameRegex = "^[a-zA-Zа-яА-ЯёЁ\\s'-]+$"
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        guard namePredicate.evaluate(with: name) else {
            error = "Name can only contain letters, spaces, hyphens and apostrophes"
            return false
        }
        
        error = nil
        return true
    }
    
    private func validateSignIn() -> Bool {
        // Проверка на пустые поля
        guard !email.isEmpty, !password.isEmpty else {
            error = "Please fill in all fields"
            return false
        }
        
        // Проверка email на валидность
        guard isValidEmail(email) else {
            error = "Please enter a valid email address"
            return false
        }
        
        // Проверка длины пароля
        guard password.count >= 6 else {
            error = "Password must be at least 6 characters"
            return false
        }
        
        error = nil
        return true
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
