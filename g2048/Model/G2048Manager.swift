import Combine

/// 2048 game managment object.
///
/// Calculates field cells after given movement (interaction).
class G2048Manager: BoardGameManager {
    /// Movement directions enumeration.
    typealias Interaction = Direction
    enum Direction {
        case up
        case left
        case right
        case down

        /// Vertical animation direction multilplier.
        var widthMultiplier: Double {
            switch self {
            case .up: return 0
            case .left: return -1
            case .right: return 1
            case .down: return 0
            }
        }

        /// Horizontal animation direction multilplier.
        var heightMultiplier: Double {
            switch self {
            case .up: return -1
            case .left: return 0
            case .right: return 0
            case .down: return 1
            }
        }
    }

    /// Field grid sizes in cells.
    let gridSize: (width: Int, height: Int)

    /// Cells value.
    private(set) var cells: [[Int]]

    /// Game score.
    ///
    /// Calculated by adding all combined cells values.
    @Published var score: Int = 0

    /// Calculated property for empty cells list.
    private var emptyCells: [(x: Int, y: Int)] {
        var result: [(x: Int, y: Int)] = []
        for yCoord in 0..<gridSize.height {
            for xCoord in 0..<gridSize.width {
                if cells[yCoord][xCoord] == 0 {
                    result.append((x: xCoord, y: yCoord))
                }
            }
        }
        return result
    }

    /// Game manager initializer. Sets-up grid size and cells values with given field preset.
    required init(gridSize: (width: Int, height: Int), preset cells: [[Int]]) {
        self.gridSize = gridSize
        self.cells = cells

        if emptyCells.count == gridSize.width * gridSize.height {
            addRandomCell()
            addRandomCell()
            addRandomCell()
        }
    }

    /// Game manager initializer. Sets-up grid size and cells values.
    convenience init(gridSize: (width: Int, height: Int)) {
        self.init(
            gridSize: gridSize,
            preset: Array(
                repeating: Array(repeating: 0, count: gridSize.width),
                count: gridSize.height
            )
        )
    }

    /// Skips all zeroes for a given row.
    ///
    /// Difficulty: O(gridSize.width).
    private func pushRow(yCoord: Int, isLeft: Bool) -> [IntPair: IntPair] {
        var replacements = [IntPair: IntPair]()

        var zeroes = isLeft ? 0 : gridSize.width - 1
        var values = isLeft ? 1 : gridSize.width - 2

        while isLeft && values <  gridSize.width ||
              !isLeft && values >= 0 {
            if cells[yCoord][zeroes] <= 0 {
                if cells[yCoord][values] > 0 {
                    cells[yCoord].swapAt(zeroes, values)
                    replacements[(values, yCoord)] = IntPair((zeroes, yCoord))
                    zeroes += isLeft ? 1 : -1
                }
            } else {
                zeroes += isLeft ? 1 : -1
            }
            values += isLeft ? 1 : -1
        }
        return replacements
    }

    /// Skips all zeroes for a given column.
    ///
    /// Difficulty: O(gridSize.height).
    private func pushColumn(xCoord: Int, isUp: Bool) -> [IntPair: IntPair] {
        var replacements = [IntPair: IntPair]()

        var zeroes = isUp ? 0 : gridSize.height - 1
        var values = isUp ? 1 : gridSize.height - 2

        while isUp && values < gridSize.height ||
              !isUp && values >= 0 {
            if cells[zeroes][xCoord] <= 0 {
                if cells[values][xCoord] > 0 {
                    let tmp = cells[zeroes][xCoord]
                    cells[zeroes][xCoord] = cells[values][xCoord]
                    cells[values][xCoord] = tmp
                    replacements[(xCoord, values)] = IntPair((xCoord, zeroes))
                    zeroes += isUp ? 1 : -1
                }
            } else {
                zeroes += isUp ? 1 : -1
            }
            values += isUp ? 1 : -1
        }
        return replacements
    }

    /// Utility function.
    private func restore(
        newFrom: IntPair,
        newTo: IntPair,
        pushed: [IntPair: IntPair],
        replacements: inout [IntPair: IntPair])
    -> Bool {
        var result = false
        pushed.forEach { (from: IntPair, to: IntPair) in
            if to == newFrom {
                replacements[from] = newTo
                result = true
            }
        }
        return result
    }

    /// Calculates new field after horizontal movement.
    ///
    /// Difficulty: O(gridSize.height \* gridSize.width).
    private func manageHorizontal(isLeft: Bool) -> [IntPair: IntPair] {
        var replacements = [IntPair: IntPair]()

        for yCoord in 0..<gridSize.height {
            let pushed = pushRow(yCoord: yCoord, isLeft: isLeft)
            replacements.merge(pushed) { (old, _) in old }

            if isLeft {
                for xCoord in 0..<cells[yCoord].count - 1 {
                    if cells[yCoord][xCoord] != 0 && cells[yCoord][xCoord] == cells[yCoord][xCoord + 1] {
                        cells[yCoord][xCoord] *= 2
                        score += cells[yCoord][xCoord]
                        cells[yCoord][xCoord + 1] = 0

                        if !restore(
                            newFrom: IntPair((xCoord + 1, yCoord)),
                            newTo: IntPair((xCoord, yCoord)),
                            pushed: pushed,
                            replacements: &replacements) {
                            replacements[(xCoord + 1, yCoord)] = IntPair((xCoord, yCoord))
                        }
                    }
                }
            } else {
                for xCoord in (1..<cells[yCoord].count).reversed() {
                    if cells[yCoord][xCoord] != 0 && cells[yCoord][xCoord] == cells[yCoord][xCoord - 1] {
                        cells[yCoord][xCoord] *= 2
                        score += cells[yCoord][xCoord]
                        cells[yCoord][xCoord - 1] = 0

                        if !restore(
                            newFrom: IntPair((xCoord - 1, yCoord)),
                            newTo: IntPair((xCoord, yCoord)),
                            pushed: pushed,
                            replacements: &replacements) {
                            replacements[(xCoord - 1, yCoord)] = IntPair((xCoord, yCoord))
                        }
                    }
                }
            }

            let newPushed = pushRow(yCoord: yCoord, isLeft: isLeft)
            newPushed.forEach { (from: IntPair, to: IntPair) in
                if !restore(newFrom: from, newTo: to, pushed: pushed, replacements: &replacements) {
                    replacements[from] = to
                }
            }

            // replacements.merge(pushRow(yCoord: yCoord, isLeft: isLeft)) { (_, new) in new }
        }
        return replacements
    }

    /// Calculates new field after vertical movement.
    ///
    /// Difficulty: O(gridSize.width \* gridSize.height).
    private func manageVertical(isUp: Bool) -> [IntPair: IntPair] {
        var replacements = [IntPair: IntPair]()

        for xCoord in 0..<gridSize.width {
            let pushed = pushColumn(xCoord: xCoord, isUp: isUp)
            replacements.merge(pushed) { (old, _) in old }

            if isUp {
                for yCoord in 0..<gridSize.height - 1 {
                    if cells[yCoord][xCoord] != 0 && cells[yCoord][xCoord] == cells[yCoord + 1][xCoord] {
                        cells[yCoord][xCoord] *= 2
                        score += cells[yCoord][xCoord]
                        cells[yCoord + 1][xCoord] = 0

                        if !restore(
                            newFrom: IntPair((xCoord, yCoord + 1)),
                            newTo: IntPair((xCoord, yCoord)),
                            pushed: pushed,
                            replacements: &replacements) {
                            replacements[(xCoord, yCoord + 1)] = IntPair((xCoord, yCoord))
                        }
                    }
                }
            } else {
                for yCoord in (1..<gridSize.height).reversed() {
                    if cells[yCoord][xCoord] != 0 && cells[yCoord][xCoord] == cells[yCoord - 1][xCoord] {
                        cells[yCoord][xCoord] *= 2
                        score += cells[yCoord][xCoord]
                        cells[yCoord - 1][xCoord] = 0

                        if !restore(
                            newFrom: IntPair((xCoord, yCoord - 1)),
                            newTo: IntPair((xCoord, yCoord)),
                            pushed: pushed,
                            replacements: &replacements) {
                            replacements[(xCoord, yCoord - 1)] = IntPair((xCoord, yCoord))
                        }
                    }
                }
            }

            let newPushed = pushColumn(xCoord: xCoord, isUp: isUp)
            newPushed.forEach { (from: IntPair, to: IntPair) in
                if !restore(newFrom: from, newTo: to, pushed: pushed, replacements: &replacements) {
                    replacements[from] = to
                }
            }
            // pushColumn(xCoord: xCoord, isUp: isUp)
        }
        return replacements
    }

    /// Calculates new field after swipe with given direction.
    ///
    /// Difficulty: O(gridSize.height \* gridSize.width).
    func makeTurn(_ interaction: Direction) -> [IntPair: IntPair] {
        switch interaction {
        case .left:
            return manageHorizontal(isLeft: true)
        case .right:
            return manageHorizontal(isLeft: false)
        case .up:
            return manageVertical(isUp: true)
        case .down:
            return manageVertical(isUp: false)
        }
    }

    /// Adds new valid cell in a random empty place.
    ///
    /// Difficulty: O(gridSize.height \* gridSize.width).
    func addRandomCell() {
        guard let coord = emptyCells.randomElement() else { return }
        cells[coord.y][coord.x] = Int.random(in: 1...2) * 2
    }
}
