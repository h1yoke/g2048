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

    /// Main menu body.
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            MenuButton(text: "play", color: .gray, action: {})
            MenuButton(text: "settings", color: .brown, action: {})
            MenuButton(text: "highscores", color: .yellow, action: {})
        }
        .foregroundStyle(.white)
        .frame(maxWidth: 500)
        .padding(.horizontal, 30.0)
        .font(.title)
    }
}

/// Main menu view editor preview.
struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
