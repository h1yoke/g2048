import SwiftUI

/// View modifier for *swipe* action.
struct SwipeModifier: ViewModifier {
    private let action: (DragGesture.Value) -> Void

    /// Modifier initializer. Takes closure that executes on swipe register.
    init(action: @escaping (DragGesture.Value) -> Void = {_ in}) {
        self.action = action
    }

    /// Modifier body. Performs `action` on swipe.
    func body(content: Content) -> some View {
        content
            .gesture(DragGesture(minimumDistance: 30)
                .onEnded(action)
            )
    }
}

/// `View` extension for more convenient `SwipeModifier` usage.
extension View {
    /// Executes given closure on *swipe* action.
    func onSwipe(action: @escaping (DragGesture.Value) -> Void) -> some View {
        modifier(SwipeModifier(action: action))
    }
}
