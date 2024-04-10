import Combine

/// Board game manager protocol.
///
/// Defines a default behaivour of a turn-based single player board game.
/// Game consists of a grid with integer cells. Player makes a turn with `makeTurn` method
/// and manager updates `cells` and `score` to new corresponding values.
protocol BoardGameManager: ObservableObject {
    /// Defines player interaction for a specific board game.
    associatedtype Interaction

    /// Board field grid size values in cells.
    var gridSize: (width: Int, height: Int) { get }

    /// Board cells values.
    var cells: [[Int]] { get }

    /// Game intermediate score.
    var score: Int { get }

    /// *Is ended* game state.
    var isEnded: Bool { get }

    /// Game manager initializer. Sets-up grid size and cells values.
    init(gridSize: (width: Int, height: Int), preset cells: [[Int]])

    /// Calculates new field after defined interaction.
    func makeTurn(_ interaction: Interaction) -> [IntPair: IntPair]
}
