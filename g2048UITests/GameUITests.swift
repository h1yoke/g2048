import XCTest

/// `GameViewModel` ui testing model.
final class GameUITests: XCTestCase {
    var app: XCUIApplication!

    /// Testing preparation. Navigating to game tab.
    override func setUpWithError() throws {
        app = XCUIApplication()
        continueAfterFailure = false
        app.launch()

        app.buttons["play"].tap()
    }

    /// Testing after-actions. Pressing "stop" button.
    override func tearDownWithError() throws {
        app.buttons["stop.circle"].tap()
    }

    /// Test if game is btble.
    func testGameCompletion() throws {
        while !app.staticTexts["Game ended!"].exists {
            [app.swipeRight, app.swipeLeft, app.swipeUp, app.swipeDown]
                .shuffled()
                .forEach { $0() }
        }
    }
}
