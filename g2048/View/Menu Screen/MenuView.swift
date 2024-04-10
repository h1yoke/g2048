import SwiftUI

/// Main menu View.
struct MenuView: View {
    /// Standart main menu button View.
    struct MenuButton: View {
        /// Button label.
        var text: String
        /// Button capsule color.
        var color: Color
        /// Button performing action.
        var action: () -> Void

        /// Default button initializer.
        init(text: String, color: Color, action: @escaping () -> Void) {
            self.text = text
            self.color = color
            self.action = action
        }

        /// Button view body.
        var body: some View {
            Button(action: action, label: {
                Text(text)
                    .padding()
                    .frame(maxWidth: .infinity)
            })
            .background(color)
            .clipShape(Capsule())
        }
    }

    /// Play button pressed state.
    @Binding var selectedScene: AppScene

    /// Main menu body.
    var body: some View {
        ZStack {
            /// Background for game scene.
            Rectangle()
                .foregroundColor(Color("Background"))
                .ignoresSafeArea()
            /// Menu buttons.
            VStack(alignment: .center, spacing: 10) {
                MenuButton(text: "play", color: Color("BoardDark"), action: {
                    self.selectedScene = .inGame
                })
                MenuButton(text: "highscores", color: Color("BoardDark"), action: {
                    self.selectedScene = .highScores
                })
            }
            .foregroundStyle(.white)
            .frame(maxWidth: 500)
            .padding(.horizontal, 30.0)
            .font(.title)
        }
    }
}

/// Main menu view editor preview.
struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(selectedScene: .constant(.mainMenu))
    }
}
