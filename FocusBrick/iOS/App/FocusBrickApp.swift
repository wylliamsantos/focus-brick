import SwiftUI

@main
struct FocusBrickApp: App {
    @StateObject private var purchaseService = PurchaseService()
    @StateObject private var timerViewModel = TimerViewModel(
        store: UserDefaultsSessionStore(),
        notificationService: UserNotificationService(),
        watchConnectivityService: WatchConnectivityService.shared
    )

    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: timerViewModel)
                .environmentObject(purchaseService)
                .preferredColorScheme(.light)
                .onOpenURL { url in
                    timerViewModel.handleDeepLink(url)
                }
        }
    }
}
