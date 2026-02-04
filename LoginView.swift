//
//  LoginView.swift
//  MemeAtlas
//
//  Created by Suresh on 21/12/2025.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var showSignUp = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Gradient de fond
                LinearGradient(
                    colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // Logo et titre
                    VStack(spacing: 15) {
                        Image(systemName: "globe")
                            .font(.system(size: 80))
                            .foregroundColor(.white)
                        
                        Text("MemeAtlas")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Bienvenue !")
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.bottom, 40)
                    
                    // Formulaire de connexion
                    VStack(spacing: 20) {
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
                        
                        // Bouton "Mot de passe oublié"
                        HStack {
                            Spacer()
                            Button("Mot de passe oublié ?") {
                                // Action à venir
                            }
                            .font(.footnote)
                            .foregroundColor(.white)
                        }
                        
                        // Bouton de connexion
                        Button(action: {
                            viewModel.login(email: email, password: password)
                        }) {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            } else {
                                Text("Se connecter")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                                    .shadow(color: .blue.opacity(0.5), radius: 10, x: 0, y: 5)
                            }
                        }
                        .disabled(viewModel.isLoading || email.isEmpty || password.isEmpty)
                        
                        // Message d'erreur
                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.caption)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.horizontal, 30)
                    
                    // Lien vers l'inscription
                    HStack {
                        Text("Pas encore de compte ?")
                            .foregroundColor(.white)
                        
                        Button("S'inscrire") {
                            showSignUp = true
                        }
                        .foregroundColor(.yellow)
                        .fontWeight(.bold)
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                }
                .padding(.top, 60)
            }
            .navigationDestination(isPresented: $showSignUp) {
                SignUpView()
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
