//
//  GameManager.swift
//  g2048
//
//  Created by Dmitry Protsenko on 05.04.2024.
//

import Foundation

class GameManager: ObservableObject {
    enum Direction {
        case up
        case left
        case right
        case down
    }

    private(set) var cells: [[Int]]
    private let gridSize: (width: Int, height: Int)
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
    var score: Int {
        cells.reduce(0) { $0 + $1.reduce(0, +) }
    }

    init(gridSize: (width: Int, height: Int)) {
        self.gridSize = gridSize
        self.cells = Array(
            repeating: Array(repeating: 0, count: gridSize.width),
            count: gridSize.height
        )
        for yCoord in 0..<gridSize.height {
            for xCoord in 0..<gridSize.width {
                cells[yCoord][xCoord] = Int.random(in: 0...2) * 2
            }
        }
    }

    private func pushRow(yCoord: Int, isLeft: Bool) {
        var zeroes = isLeft ? 0 : gridSize.width - 1
        var values = isLeft ? 1 : gridSize.width - 2

        while isLeft && values <  gridSize.width ||
              !isLeft && values >= 0 {
            if cells[yCoord][zeroes] <= 0 {
                if cells[yCoord][values] > 0 {
                    cells[yCoord].swapAt(zeroes, values)
                    zeroes += isLeft ? 1 : -1
                }
            } else {
                zeroes += isLeft ? 1 : -1
            }
            values += isLeft ? 1 : -1
        }
    }

    private func pushColumn(xCoord: Int, isUp: Bool) {
        var zeroes = isUp ? 0 : gridSize.height - 1
        var values = isUp ? 1 : gridSize.height - 2

        while isUp && values < gridSize.height ||
              !isUp && values >= 0 {
            if cells[zeroes][xCoord] <= 0 {
                if cells[values][xCoord] > 0 {
                    let tmp = cells[zeroes][xCoord]
                    cells[zeroes][xCoord] = cells[values][xCoord]
                    cells[values][xCoord] = tmp
                    zeroes += isUp ? 1 : -1
                }
            } else {
                zeroes += isUp ? 1 : -1
            }
            values += isUp ? 1 : -1
        }
    }

    private func manageHorizontal(isLeft: Bool) {
        for yCoord in 0..<gridSize.height {
            pushRow(yCoord: yCoord, isLeft: isLeft)
            if isLeft {
                for xCoord in 0..<cells[yCoord].count - 1 {
                    if cells[yCoord][xCoord] == cells[yCoord][xCoord + 1] {
                        cells[yCoord][xCoord] *= 2
                        cells[yCoord][xCoord + 1] = 0
                    }
                }
            } else {
                for xCoord in (1..<cells[yCoord].count).reversed() {
                    if cells[yCoord][xCoord] == cells[yCoord][xCoord - 1] {
                        cells[yCoord][xCoord] *= 2
                        cells[yCoord][xCoord - 1] = 0
                    }
                }
            }
            pushRow(yCoord: yCoord, isLeft: isLeft)
        }
    }

    private func manageVertical(isUp: Bool) {
        for xCoord in 0..<gridSize.width {
            pushColumn(xCoord: xCoord, isUp: isUp)
            if isUp {
                for yCoord in 0..<gridSize.height - 1 {
                    if cells[yCoord][xCoord] == cells[yCoord + 1][xCoord] {
                        cells[yCoord][xCoord] *= 2
                        cells[yCoord + 1][xCoord] = 0
                    }
                }
            } else {
                for yCoord in (1..<gridSize.height).reversed() {
                    if cells[yCoord][xCoord] == cells[yCoord - 1][xCoord] {
                        cells[yCoord][xCoord] *= 2
                        cells[yCoord - 1][xCoord] = 0
                    }
                }
            }
            pushColumn(xCoord: xCoord, isUp: isUp)
        }
    }

    func manageSwipe(direction: Direction) {
        switch direction {
        case .left:
            manageHorizontal(isLeft: true)
        case .right:
            manageHorizontal(isLeft: false)
        case .up:
            manageVertical(isUp: true)
        case .down:
            manageVertical(isUp: false)
        }
    }

    func addRandomCell() {
        guard let coord = emptyCells.randomElement() else { return }
        cells[coord.y][coord.x] = 2
    }
}
