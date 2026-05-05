import SwiftUI

@main
struct FocusBrickApp: App {
    @StateObject private var timerViewModel = TimerViewModel()

    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: timerViewModel)
                .preferredColorScheme(.light)
        }
    }
}
