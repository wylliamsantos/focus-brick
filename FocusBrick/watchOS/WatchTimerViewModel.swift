import Foundation

@MainActor
final class WatchTimerViewModel: ObservableObject {
    @Published var phaseLabel: String = "Foco"
    @Published var displayTime: String = "25:00"
    @Published var isRunning: Bool = false

    func toggleRunPause() {
        isRunning.toggle()
        // Placeholder: comando será enviado via WatchConnectivity para o iPhone.
    }

    func reset() {
        isRunning = false
        displayTime = "25:00"
    }

    func apply(_ state: WatchSessionState) {
        phaseLabel = state.phaseLabel
        displayTime = state.displayTime
        isRunning = state.isRunning
    }
}
