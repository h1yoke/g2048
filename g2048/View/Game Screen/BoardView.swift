import SwiftUI

/// 2048 board view.
struct BoardView: View {
    /// Game manager object, that operates all board states.
    ///
    /// Passed as a parameter from `ViewModel` object, such as `GameViewModel`.
    @ObservedObject var manager: G2048Manager

    /// Cell values, that are drawn on board.
    @State var cells: [[Int]]

    /// Cell view offsets, that operates all in-game animations.
    @State var offsets: [[CGSize]]

    /// Cell view size, that is computed in run-time.
    @State var size = CGSize.zero

    /// Grid cell spacing.
    let cellSpacing: Double = 10

    /// Timer for cell updates after animations are complete.
    @State var updateTimer: Timer?

    /// Board view initializer.
    init(manager: G2048Manager) {
        self.manager = manager
        self.cells = manager.cells
        self.offsets = Array(
            repeating: Array(repeating: .zero, count: manager.gridSize.width),
            count: manager.gridSize.height
        )
    }

    /// View body.
    var body: some View {
        ZStack {
            backView
            cellsView
                .padding()
        }
        .onSwipe(action: processSwipe)
    }

    /// Back pannel view.
    var backView: some View {
        ZStack {
            /// Back pannel.
            Rectangle()
                .fill(Color("Board"))
                .cornerRadius(15)
                .aspectRatio(contentMode: .fit)
            /// Cell sockets.
            VStack(spacing: cellSpacing) {
                ForEach(0..<manager.gridSize.height, id: \.self) { _ in
                    HStack(spacing: cellSpacing) {
                        ForEach(0..<manager.gridSize.width, id: \.self) { _ in
                            Rectangle()
                                .fill(Color("BoardDark"))
                                .cornerRadius(15)
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                }
            }
            .padding()
        }
    }

    /// Game cells view.
    var cellsView: some View {
        /// Generates `manager.gridSize.height` \* `manager.gridSize.height` cells.
        VStack(spacing: cellSpacing) {
            ForEach(0..<manager.gridSize.height, id: \.self) { horInd in
                HStack(spacing: cellSpacing) {
                    ForEach(0..<manager.gridSize.width, id: \.self) { vertInd in
                        CellView(value: cells[horInd][vertInd])
                            .offset(offsets[horInd][vertInd])
                            .background() {
                                /// Get cell size in run-time for animation compute.
                                GeometryReader { geometry in
                                    Path { _ in
                                        DispatchQueue.main.async {
                                            if self.size != geometry.size {
                                                self.size = geometry.size
                                            }
                                        }
                                    }
                                }
                            }
                    }
                }
            }
        }
    }

    /// Calculate new positions for cells and animate transitions.
    private func animateSwipe(direction: G2048Manager.Direction) {
        /// Animate cell transitions.
        let transitions = manager.makeTurn(direction)
        withAnimation(.linear(duration: 0.2)) {
            transitions.forEach { (from: IntPair, to: IntPair) in
                let width: Double =
                    (size.width + cellSpacing) *
                    Double(abs(from.int0 - to.int0)) *
                    direction.widthMultiplier
                let height: Double =
                    (size.height + cellSpacing) *
                    Double(abs(from.int1 - to.int1)) *
                    direction.heightMultiplier
                offsets[from.int1][from.int0] = CGSize(width: width, height: height)
            }
        }

        /// Set timer on cell value updates.
        updateTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
            cells = manager.cells
            self.offsets = Array(
                repeating: Array(repeating: .zero, count: manager.gridSize.width),
                count: manager.gridSize.height
            )
            updateTimer?.invalidate()

            /// Make turn and add new cell into field.
            if transitions.count > 0 {
                withAnimation(.linear(duration: 0.3)) {
                    manager.addRandomCell()
                    cells = manager.cells
                }
            }
        }
    }

    ///  Determine swipe direction from given gesture information and process in-game actions.
    private func processSwipe(gesture: DragGesture.Value) {
        let hor = gesture.translation.width
        let ver = gesture.translation.height

        if abs(hor) > abs(ver) {
            if hor > 0 {
                animateSwipe(direction: G2048Manager.Direction.right)
            } else {
                animateSwipe(direction: G2048Manager.Direction.left)
            }
        } else {
            if ver > 0 {
                animateSwipe(direction: G2048Manager.Direction.down)
            } else {
                animateSwipe(direction: G2048Manager.Direction.up)
            }
        }
    }
}

/// Board view editor preview.
 struct BoardView_Previews: PreviewProvider {
     static var previews: some View {
         BoardView(manager: G2048Manager(gridSize: (width: 4, height: 4)))
     }
 }
