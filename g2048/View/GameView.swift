//
//  GameView.swift
//  g2048
//
//  Created by Dmitry Protsenko on 05.04.2024.
//

import SwiftUI
import Foundation

struct CellView: View {
    private var value: Int

    init(value: Int = 0) {
        self.value = value
    }

    var body: some View {
        ZStack {
            Rectangle()
                .fill(color)
                .cornerRadius(10)
                .aspectRatio(contentMode: .fit)
            Text(value == 0 ? "" : "\(value)")
                .font(.title)
        }
    }
}

extension CellView {
    private var color: Color {
        switch value {
        case 0:
            return .brown
        case 2:
            return .orange
        case 4:
            return .green
        case 8:
            return .blue
        case 16:
            return .purple
        case 32:
            return .pink
        case 64:
            return .red
        case 128:
            return .yellow
        default:
            return .white
        }
    }
}

struct GameView: View {
    let gridSize = (width: 4, height: 4)
    var manager: GameManager

    @State var cells: [[Int]]
    @State var score: Int

    init() {
        self.manager = GameManager(gridSize: gridSize)
        self.cells = manager.cells
        self.score = manager.score
    }

    var body: some View {
        VStack {
            Text("Score: \(score)")
                .font(.title)
            ZStack {
                Rectangle()
                    .fill(.gray)
                    .cornerRadius(15)
                    .aspectRatio(contentMode: .fit)
                VStack(spacing: 10) {
                    ForEach(0..<gridSize.height, id: \.self) { horInd in
                        HStack(spacing: 10) {
                            ForEach(0..<gridSize.width, id: \.self) { vertInd in
                                CellView(value: self.cells[horInd][vertInd])
                            }
                        }
                    }
                }
                .padding(.all)
                .gesture(DragGesture(minimumDistance: 30)
                    .onEnded { gesture in
                        let hor = gesture.translation.width
                        let ver = gesture.translation.height

                        if abs(hor) > abs(ver) {
                            if hor > 0 {
                                manager.manageSwipe(direction: GameManager.Direction.right)
                            } else {
                                manager.manageSwipe(direction: GameManager.Direction.left)
                            }
                        } else {
                            if ver > 0 {
                                manager.manageSwipe(direction: GameManager.Direction.down)
                            } else {
                                manager.manageSwipe(direction: GameManager.Direction.up)
                            }
                        }
                        manager.addRandomCell()
                        self.cells = manager.cells
                        self.score = manager.score
                    })
            }
        }
    }

}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
