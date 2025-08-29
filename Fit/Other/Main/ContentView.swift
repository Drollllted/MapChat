//
//  ContentView.swift
//  Fit
//
//  Created by Drolllted on 29.08.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        Group {
            if authViewModel.isAuthenticated, let userId = authViewModel.currentUser?.uid {
                MapView(userId: userId)
            } else {
                SignInView(authViewModel: authViewModel)
            }
        }
        .onAppear {
            if authViewModel.currentUser != nil {
                authViewModel.isAuthenticated = true
            }
        }
    }
}

#if DEBUG
#Preview {
    ContentView()
}
#endif
