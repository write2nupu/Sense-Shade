import SwiftUI

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

struct RootView: View {
    
    @AppStorage("hasSeenIntro") private var hasSeenIntro = false
    
    var body: some View {
        Group {
            if hasSeenIntro {
                ContentView()
            } else {
                WelcomeView()
            }
        }
    }
}
