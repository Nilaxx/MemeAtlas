import SwiftUI
import Firebase

@main
struct MemeAtlasApp: App {
    init() {
        // C'est l'appel crucial qui initialise Firebase
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}
