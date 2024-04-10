import SwiftUI

/// Application entry point.
@main
struct G2048App: App {
    let persistenceController = RecordPersistence.shared
    @State var selectedScene: AppScene = .mainMenu

    var body: some Scene {
        WindowGroup {
            switch selectedScene {
            case .mainMenu:
                MenuView(selectedScene: $selectedScene)
            case .inGame:
                GameViewModel(selectedScene: $selectedScene)
                    .environment(\.managedObjectContext,
                        persistenceController.container.viewContext)
            case .highScores:
                RecordView(selectedScene: $selectedScene)
                    .environment(\.managedObjectContext,
                        persistenceController.container.viewContext)
            }
        }
    }
}
