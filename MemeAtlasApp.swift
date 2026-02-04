// MemeAtlasApp.swift
import SwiftUI
import Firebase

@main
struct MemeAtlasApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            if authViewModel.isAuthenticated {
                VStack {
                    Text("Connecté ! Bienvenue sur la Carte 🗺️")
                    Button("Se déconnecter") {
                        authViewModel.logout()
                    }
                }
            } else {
                LoginView()
                    .environmentObject(authViewModel)
            }
        }
    }
}
