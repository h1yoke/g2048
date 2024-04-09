import SwiftUI

/// Application entry point.
@main
struct G2048App: App {
    var body: some Scene {
        WindowGroup {
            GameViewModel()
        }
    }
}
