import SwiftUI

/// Game ViewModel element that compilates board and game info into a complete scene.
struct GameViewModel: View {
    /// 2048 Game manager object.
    @StateObject var model = G2048Manager(gridSize: (width: 4, height: 4))

    /// Scene body.
    var body: some View {
        ZStack {
            /// Background for game scene.
            Rectangle()
                .foregroundColor(Color("Background"))
                .ignoresSafeArea()
            ZStack(alignment: .topTrailing) {
                VStack {
                    /// Game score text field.
                    Text("Score: \(model.score)")
                        .font(.title)
                        .padding()
                        .frame(minWidth: 200)
                        .background(Color("Board"))
                        .clipShape(Capsule())
                    /// Game view.
                    BoardView(manager: model)
                        .padding()
                }
                /// Pause button.
                Button {
                } label: {
                    Image(systemName: "pause.circle")
                        .resizable()
                        .foregroundColor(Color("BoardDark"))
                }
                .aspectRatio(1.0, contentMode: .fit)
                .frame(maxWidth: 60, maxHeight: 60)
                .padding()
                .offset(x: -10, y: -125)
            }
        }
    }

}

/// Game ViewModel editor preview.
struct GameViewModel_Previews: PreviewProvider {
    static var previews: some View {
        GameViewModel()
    }
}
