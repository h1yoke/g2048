import XCTest

/// `MenuView` ui testing module.
final class MainMenuUITests: XCTestCase {
    var app: XCUIApplication!

    /// Tests preparation.
    override func setUpWithError() throws {
        app = XCUIApplication()
        continueAfterFailure = false
        app.launch()
    }

    /// Testing transition to highscores tab.
    func testHighscoresButton() throws {
        app.buttons["highscores"].tap()
        app.swipeRight()
    }

    /// Testing transition to game tab.
    func testGameButton() throws {
        let app = XCUIApplication()
        app.buttons["play"].tap()
        app.buttons["stop.circle"].tap()
    }
}
