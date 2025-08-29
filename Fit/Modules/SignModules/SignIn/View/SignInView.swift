//
//  SignInView.swift
//  Fit
//
//  Created by Drolllted on 28.08.2025.
//

import SwiftUI

struct SignInView: View {
    
    @EnvironmentObject private var vm: AuthViewModel
    
    var body: some View {
        ZStack {
            Color(UIColor(red: 0.97, green: 0.98, blue: 0.99, alpha: 1.00))
                .ignoresSafeArea()
            
            VStack {
                CustomTextField(icon: "envelope.fill", placeholder: "Write your's email", text: $vm.email)
                CustomTextField(icon: "lock.fill", placeholder: "Write your's password", text: $vm.password)
                
                Button {
                    Task {
                        vm.signIn()
                    }
                } label: {
                    Text("Let's go")
                }
                
                NavigationLink {
                    SignUpView()
                } label: {
                    Text("Go To Sign Up")
                }


            }
        }
    }
}

#if DEBUG
#Preview {
    SignInView()
}
#endif
