import SwiftUI

@main
struct FocusBrickWatchApp: App {
    var body: some Scene {
        WindowGroup {
            WatchHomeView(viewModel: WatchTimerViewModel())
        }
    }
}
