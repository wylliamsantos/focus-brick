import SwiftUI

// watchOS app entrypoint should live in a dedicated watch target.
// Kept as a regular view container to avoid duplicate @main in single-target setups.
struct FocusBrickWatchRootView: View {
    var body: some View {
        WatchHomeView(viewModel: WatchTimerViewModel())
    }
}
