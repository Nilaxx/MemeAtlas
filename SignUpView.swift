//
//  SignUpView.swift
//  MemeAtlas
//
//  Created by Suresh on 21/12/2025.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    var body: some View {
        ZStack {
            // Gradient de fond
            LinearGradient(
                colors: [Color.purple.opacity(0.6), Color.pink.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 25) {
                    // Titre
                    VStack(spacing: 10) {
                        Image(systemName: "person.crop.circle.badge.plus")
                            .font(.system(size: 70))
                            .foregroundColor(.white)
                        
                        Text("Créer un compte")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 30)
                    
                    // Formulaire d'inscription
                    VStack(spacing: 20) {
                        // Champ Nom d'utilisateur
                        TextField("Nom d'utilisateur", text: $username)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .autocapitalization(.none)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                        
                        // Champ Email
                        TextField("Email", text: $email)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                        
                        // Champ Mot de passe
                        SecureField("Mot de passe", text: $password)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                        
                        // Champ Confirmation mot de passe
                        SecureField("Confirmer le mot de passe", text: $confirmPassword)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                        
                        // Validation du mot de passe
                        if !password.isEmpty && !confirmPassword.isEmpty {
                            if password == confirmPassword {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                    Text("Les mots de passe correspondent")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                }
                            } else {
                                HStack {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                    Text("Les mots de passe ne correspondent pas")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        
                        // Bouton d'inscription
                        Button(action: {
                            viewModel.signUp(username: username, email: email, password: password)
                        }) {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            } else {
                                Text("S'inscrire")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.purple)
                                    .cornerRadius(10)
                                    .shadow(color: .purple.opacity(0.5), radius: 10, x: 0, y: 5)
                            }
                        }
                        .disabled(
                            viewModel.isLoading ||
                            username.isEmpty ||
                            email.isEmpty ||
                            password.isEmpty ||
                            password != confirmPassword
                        )
                        
                        // Message d'erreur
                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.caption)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.horizontal, 30)
                    
                    // Lien vers la connexion
                    HStack {
                        Text("Déjà un compte ?")
                            .foregroundColor(.white)
                        
                        Button("Se connecter") {
                            dismiss()
                        }
                        .foregroundColor(.yellow)
                        .fontWeight(.bold)
                    }
                    .padding(.top, 20)
                    
                    Spacer(minLength: 50)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                }
            }
        }
    }
}

#Preview {
    SignUpView()
}
