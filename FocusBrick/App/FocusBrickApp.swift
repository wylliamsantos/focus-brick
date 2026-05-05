import SwiftUI

@main
struct FocusBrickApp: App {
    @StateObject private var timerViewModel = TimerViewModel()
    @StateObject private var purchaseService = PurchaseService()

    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: timerViewModel)
                .environmentObject(purchaseService)
                .preferredColorScheme(.light)
        }
    }
}
