import XCTest
@testable import g2048

/// `G2048Manager` testing module.
final class GameManagerTests: XCTestCase {
    /// Test game manager initializers.
    func testInit() {
        for width in 1...20 {
            for height in 1...20 {
                let cells = Array(
                    repeating: Array(repeating: 0, count: width),
                    count: height
                )
                XCTAssert(
                    G2048Manager(gridSize: (width: width, height: height)).score ==
                    G2048Manager(gridSize: (width: width, height: height), preset: cells).score
                )
            }
        }
    }

    /// Test left swipe response on one line row.
    func testLeft() {
        for width in 1...20 {
            /// Initial value
            let from = [Int](repeating: 2, count: width)

            /// Expected result
            var to = [Int](repeating: 4, count: width)
            for place in (width / 2)..<width { to[place] = 0 }
            if width % 2 == 1 { to[width / 2] = 2 }

            /// Testing
            let sut = G2048Manager(gridSize: (width: width, height: 1), preset: [from])
            _ = sut.makeTurn(G2048Manager.Direction.left)

            /// Check-up
            XCTAssert(sut.cells == [to])
        }
    }

    /// Test right swipe response on one line row.
    func testRight() {
        for width in 1...20 {
            /// Initial value
            let from = [Int](repeating: 2, count: width)

            /// Expected result
            var to = [Int](repeating: 4, count: width)
            for place in 0..<(width / 2) { to[place] = 0 }
            if width % 2 == 1 { to[width / 2] = 2 }

            /// Testing
            let sut = G2048Manager(gridSize: (width: width, height: 1), preset: [from])
            _ = sut.makeTurn(G2048Manager.Direction.right)

            /// Check-up
            XCTAssert(sut.cells == [to])
        }
    }

    /// Test up swipe response on one line row.
    func testUp() {
        for height in 1...20 {
            /// Initial value
            let from = [[Int]](repeating: [2], count: height)

            /// Expected result
            var to = [[Int]](repeating: [4], count: height)
            for place in (height / 2)..<height { to[place][0] = 0 }
            if height % 2 == 1 { to[height / 2][0] = 2 }

            /// Testing
            let sut = G2048Manager(gridSize: (width: 1, height: height), preset: from)
            _ = sut.makeTurn(G2048Manager.Direction.up)

            /// Check-up
            XCTAssert(sut.cells == to)
        }
    }

    /// Test down swipe response on one line row.
    func testDown() {
        for height in 1...20 {
            /// Initial value
            let from = [[Int]](repeating: [2], count: height)

            /// Expected result
            var to = [[Int]](repeating: [4], count: height)
            for place in 0..<(height / 2) { to[place][0] = 0 }
            if height % 2 == 1 { to[height / 2][0] = 2 }

            /// Testing
            let sut = G2048Manager(gridSize: (width: 1, height: height), preset: from)
            _ = sut.makeTurn(G2048Manager.Direction.down)

            /// Check-up
            XCTAssert(sut.cells == to)
        }
    }
}
