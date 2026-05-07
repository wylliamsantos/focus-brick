import Foundation
import Combine

@MainActor
final class WatchTimerViewModel: ObservableObject {
    @Published var phaseLabel: String = "Foco"
    @Published var displayTime: String = "25:00"
    @Published var isRunning: Bool = false

    private let syncService: WatchSyncService
    private var cancellables = Set<AnyCancellable>()

    init(syncService: WatchSyncService = WatchSyncService()) {
        self.syncService = syncService

        self.syncService.$latestState
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                guard let self, let state else { return }
                self.apply(state)
            }
            .store(in: &cancellables)
    }

    func toggleRunPause() {
        syncService.send(.toggleRunPause)
    }

    func reset() {
        syncService.send(.reset)
    }

    func apply(_ state: WatchSessionState) {
        phaseLabel = state.phaseLabel
        displayTime = state.displayTime
        isRunning = state.isRunning
    }
}
