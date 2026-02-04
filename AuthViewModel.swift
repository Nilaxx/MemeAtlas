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
    
    // MARK: - Initialisation & Persistance
    init() {
        // Vérifie immédiatement si un utilisateur est déjà en cache
        if Auth.auth().currentUser != nil {
            self.isAuthenticated = true
        }
        
        // Écoute les changements d'état (connexion/déconnexion venant de Firebase)
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.isAuthenticated = (user != nil)
            }
        }
    }
    
    // Connexion
    func login(email: String, password: String) {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    print("✅ Connexion réussie pour: \(authResult.user.email ?? "Inconnu")")
                }
            } catch let error as NSError {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.handleAuthError(error)
                }
            }
        }
    }
    
    // Inscription
    func signUp(username: String, email: String, password: String) {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                // 1. Création du compte utilisateur dans Firebase
                let result = try await Auth.auth().createUser(withEmail: email, password: password)
                
                // 2. Mise à jour du profil pour ajouter le nom d'utilisateur (Pseudo)
                let changeRequest = result.user.createProfileChangeRequest()
                changeRequest.displayName = username
                try await changeRequest.commitChanges()
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    // isAuthenticated passera automatiquement à true grâce au listener dans le init()
                    print("✅ Inscription réussie pour: \(username) - \(email)")
                }
            } catch let error as NSError {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.handleAuthError(error)
                }
            }
        }
    }
    
    // Déconnexion
    func logout() {
        do {
            try Auth.auth().signOut()
            // isAuthenticated passera automatiquement à false grâce au listener
            print("Déconnexion réussie")
        } catch {
            print("Erreur lors de la déconnexion: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
        }
    }
    
    // Gestion des erreurs
    private func handleAuthError(_ error: NSError) {
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
        case .emailAlreadyInUse:
            self.errorMessage = "Cette adresse email est déjà utilisée."
        case .weakPassword:
            self.errorMessage = "Le mot de passe est trop faible (6 caractères min)."
        default:
            self.errorMessage = error.localizedDescription
        }
        print("Erreur Auth: \(error.localizedDescription)")
    }
}
