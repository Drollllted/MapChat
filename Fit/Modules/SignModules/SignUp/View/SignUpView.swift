//
//  SignUpView.swift
//  Fit
//
//  Created by Drolllted on 28.08.2025.
//

import SwiftUI

struct SignUpView: View {
    
    @StateObject private var firebaseSetvice = FirebaseService()
    
    // States for text fields
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    var body: some View {
        ZStack {
            // MARK: - Background
            Color(UIColor(red: 0.97, green: 0.98, blue: 0.99, alpha: 1.00)) // #F7F9FC
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    
                    // MARK: - Header
                    VStack(spacing: 8) {
                        Image(systemName: "map.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .foregroundColor(Color(red: 0.36, green: 0.55, blue: 1.00)) // #5B8CFF
                        
                        Text("Присоединяйтесь!")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: 0.18, green: 0.22, blue: 0.28)) // #2D3748
                        
                        Text("Создайте аккаунт, чтобы начать путешествие.")
                            .font(.subheadline)
                            .foregroundColor(Color(red: 0.44, green: 0.50, blue: 0.59)) // #718096
                    }
                    .padding(.top, 40)
                    
                    // MARK: - Form Fields
                    VStack(spacing: 16) {
                        CustomTextField(icon: "person", placeholder: "Полное имя", text: $fullName)
                        CustomTextField(icon: "envelope", placeholder: "Email адрес", text: $email, keyboardType: .emailAddress)
                        CustomSecureField(icon: "lock", placeholder: "Пароль", text: $password)
                        CustomSecureField(icon: "lock.fill", placeholder: "Подтвердите пароль", text: $confirmPassword)
                    }
                    
                    // MARK: - Sign Up Button
                    Button(action: {
                        Task {
                            await firebaseSetvice.createUser(email: email, password: password)
                        }
                    }) {
                        HStack {
                            Text("Создать аккаунт")
                                .fontWeight(.bold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(red: 0.36, green: 0.55, blue: 1.00)) // #5B8CFF
                    )
                    .padding(.top, 8)
                    
                    // MARK: - Footer (Sign In Link)
                    HStack {
                        Text("Уже есть аккаунт?")
                            .foregroundColor(Color(red: 0.44, green: 0.50, blue: 0.59)) // #718096
                        
                        Button(action: {
                            // Navigate to Sign In
                        }) {
                            Text("Войти")
                                .fontWeight(.semibold)
                                .foregroundColor(Color(red: 0.36, green: 0.55, blue: 1.00)) // #5B8CFF
                        }
                    }
                    .font(.subheadline)
                    .padding(.vertical)
                }
                .padding(.horizontal, 32)
            }
        }
    }
}

struct CustomTextField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(Color(red: 0.44, green: 0.50, blue: 0.59)) // #718096
                .frame(width: 20)
            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(red: 0.92, green: 0.94, blue: 0.96), lineWidth: 1) // Light border
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                )
        )
    }
}

struct CustomSecureField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(Color(red: 0.44, green: 0.50, blue: 0.59)) // #718096
                .frame(width: 20)
            TextField(placeholder, text: $text)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(red: 0.92, green: 0.94, blue: 0.96), lineWidth: 1) // Light border
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                )
        )
    }
}

#if DEBUG
#Preview {
    SignUpView()
}
#endif
