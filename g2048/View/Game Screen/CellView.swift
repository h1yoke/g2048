import SwiftUI

/// Game cell View object.
///
/// Defines cell design and behaiviour
struct CellView: View {
    /// Cell integer value.
    private(set) var value: Int

    /// Cell coloring scheme.
    ///
    /// Uses `-1` for non-described, `0` for empty ones.
    private var colorScheme: [Int: Color]

    /// Provided default coloring scheme.
    private static let defaultColorScheme = [
        0: Color.brown,
        2: Color.orange,
        4: Color.green,
        8: Color.blue,
        16: Color.purple,
        32: Color.pink,
        64: Color.red,
        128: Color.yellow,
        -1: Color.white
    ]

    /// Cell color calculated property.
    ///
    /// Uses `Color.black` if `-1`value is undefined.
    var color: Color {
        colorScheme[value] ?? colorScheme[-1] ?? Color.black
    }

    /// Game cell view initializer.
    init(value: Int = 0, colorScheme: [Int: Color] = defaultColorScheme) {
        self.value = value
        self.colorScheme = colorScheme
    }

    /// View body.
    var body: some View {
        ZStack {
            Rectangle()
                .fill(color)
                .opacity(value > 0 ? 1 : 0)
                .cornerRadius(10)
                .aspectRatio(contentMode: .fit)
            Text(value == 0 ? "" : "\(value)")
                .font(.title)
        }
    }
}
