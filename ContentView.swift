import SwiftUI

struct ContentView: View {
    // On observe le ViewModel pour réagir aux changements
    @StateObject private var viewModel = AuthViewModel()
    
    var body: some View {
        Group {
            if viewModel.isAuthenticated {
                // Si l'utilisateur est connecté, on affiche l'accueil
                MainView()
                    .environmentObject(viewModel) // On partage le VM pour pouvoir se déconnecter
            } else {
                // Sinon, on affiche l'écran de Login
                LoginView()
                    .environmentObject(viewModel)
            }
        }
        .animation(.default, value: viewModel.isAuthenticated) // Transition fluide
    }
}

// Une vue simple pour tester l'accueil
struct MainView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Bienvenue sur MemeAtlas ! 🚀")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Button("Se déconnecter") {
                    viewModel.logout()
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
            }
            .navigationTitle("Accueil")
        }
    }
}
