//
//  AuthViewModel.swift
//  MemeAtlas
//
//  Created by Suresh on 21/12/2025.
//

import Foundation
import FirebaseAuth
import SwiftUI
import Combine

class AuthViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isAuthenticated = false
    
    func login(email: String, password: String) {
        isLoading = true
        errorMessage = nil

        Task { // Utilisez un Task pour appeler des fonctions async
            do {
                let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
                // Si la connexion réussit, vous pouvez accéder aux informations de l'utilisateur via authResult.user
                DispatchQueue.main.async {
                    self.isAuthenticated = true
                    self.isLoading = false
                    print("Connexion réussie pour l'utilisateur: \(authResult.user.email ?? "Inconnu")")
                    // Vous pouvez déclencher une navigation ici si nécessaire, ou observer `isAuthenticated` dans votre vue parente
                }
            } catch let error as NSError {
                DispatchQueue.main.async {
                    self.isLoading = false
                    // Gérer les erreurs spécifiques de Firebase Auth
                    switch AuthErrorCode(rawValue: error.code) {
                    case .operationNotAllowed:
                        self.errorMessage = "La connexion par email/mot de passe n'est pas activée."
                    case .userDisabled:
                        self.errorMessage = "Ce compte utilisateur a été désactivé."
                    case .wrongPassword:
                        self.errorMessage = "Mot de passe incorrect."
                    case .invalidEmail:
                        self.errorMessage = "Adresse email mal formée."
                    case .userNotFound:
                        self.errorMessage = "Aucun utilisateur trouvé avec cette adresse email."
                    default:
                        self.errorMessage = error.localizedDescription
                    }
                    print("Erreur de connexion: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // Fonction d'inscription (temporaire, sera remplacée par Firebase)
    func signUp(username: String, email: String, password: String) {
        isLoading = true
        errorMessage = nil
        
        // Simulation d'une requête réseau
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.isLoading = false
            
            // Validation simple pour le moment
            if username.count >= 3 && email.contains("@") && password.count >= 6 {
                self.isAuthenticated = true
                self.errorMessage = nil
                print("✅ Inscription réussie pour: \(username) - \(email)")
            } else {
                self.errorMessage = "Informations invalides. Le nom d'utilisateur doit contenir au moins 3 caractères et le mot de passe 6 caractères."
            }
        }
    }
    
    // Fonction de déconnexion
    func logout() {
        isAuthenticated = false
    }
}
