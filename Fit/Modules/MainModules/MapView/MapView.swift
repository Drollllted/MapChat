//
//  MapView.swift
//  Fit
//
//  Created by Drolllted on 29.08.2025.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var viewModel: MapViewModel
    @State private var showingFriendsList = false
    @EnvironmentObject private var authViewModel: AuthViewModel
    
    
    init(userId: String) {
        _viewModel = StateObject(wrappedValue: MapViewModel(userId: userId))
    }
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $viewModel.region,
                showsUserLocation: true,
                annotationItems: viewModel.friends) { friend in
                MapAnnotation(coordinate: friend.location?.coordinate ?? CLLocationCoordinate2D()) {
                    FriendAnnotationView(friend: friend)
                }
            }
            .ignoresSafeArea()
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        showingFriendsList.toggle()
                    }) {
                        Image(systemName: "person.2.fill")
                            .padding()
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .padding()
                }
                
                Spacer()
                
                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                        .background(Color.white)
                        .clipShape(Circle())
                }
            }
        }
        .sheet(isPresented: $showingFriendsList) {
            FriendsListView(friends: viewModel.friends)
        }
        .alert("Error", isPresented: .constant(viewModel.error != nil)) {
            Button("OK") { viewModel.error = nil }
        } message: {
            Text(viewModel.error?.localizedDescription ?? "")
        }
        .onAppear {
            viewModel.startTracking()
        }
        .onDisappear {
            viewModel.stopTracking()
        }
    }
}

struct FriendAnnotationView: View {
    let friend: User
    
    var body: some View {
        VStack {
            Image(systemName: "person.circle.fill")
                .foregroundColor(.blue)
                .font(.title2)
            
            Text(friend.name)
                .font(.caption)
                .padding(4)
                .background(Color.white)
                .cornerRadius(4)
        }
    }
}

struct FriendsListView: View {
    let friends: [User]
    
    var body: some View {
        NavigationView {
            List(friends, id: \.id) { friend in
                HStack {
                    Image(systemName: "person.circle.fill")
                    Text(friend.name)
                    Spacer()
                    if friend.isOnline {
                        Text("Online")
                            .foregroundColor(.green)
                            .font(.caption)
                    }
                }
            }
            .navigationTitle("Friends")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


//
//#if DEBUG
//#Preview {
//    MapView(userId: <#String#>)
//}
//#endif
