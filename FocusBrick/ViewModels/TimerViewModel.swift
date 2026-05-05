import Foundation

@MainActor
final class TimerViewModel: ObservableObject {
    enum Phase: String {
        case focus = "Foco"
        case shortBreak = "Pausa"
        case longBreak = "Pausa Longa"

        var defaultDuration: Int {
            switch self {
            case .focus: return 25 * 60
            case .shortBreak: return 5 * 60
            case .longBreak: return 15 * 60
            }
        }
    }

    @Published private(set) var displayTime: String
    @Published private(set) var currentPhaseLabel: String
    @Published private(set) var phase: Phase
    @Published private(set) var isRunning: Bool = false

    private var timer: Timer?
    private(set) var secondsRemaining: Int
    private var completedFocusSessions: Int = 0

    init() {
        self.phase = .focus
        self.secondsRemaining = phase.defaultDuration
        self.displayTime = Self.format(seconds: secondsRemaining)
        self.currentPhaseLabel = phase.rawValue
    }

    deinit {
        timer?.invalidate()
    }

    func start() {
        guard !isRunning else { return }
        isRunning = true
        startTicker()
    }

    func pause() {
        guard isRunning else { return }
        isRunning = false
        timer?.invalidate()
        timer = nil
    }

    func resume() {
        start()
    }

    func reset() {
        pause()
        secondsRemaining = phase.defaultDuration
        refreshPresentation()
    }

    func skip() {
        pause()
        completeCurrentPhaseAndAdvance()
    }

    private func startTicker() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            Task { @MainActor in
                self.tick()
            }
        }
    }

    private func tick() {
        guard isRunning else { return }

        if secondsRemaining > 0 {
            secondsRemaining -= 1
            refreshPresentation()
        }

        if secondsRemaining == 0 {
            completeCurrentPhaseAndAdvance()
            if isRunning {
                startTicker()
            }
        }
    }

    private func completeCurrentPhaseAndAdvance() {
        switch phase {
        case .focus:
            completedFocusSessions += 1
            phase = completedFocusSessions.isMultiple(of: 4) ? .longBreak : .shortBreak
        case .shortBreak, .longBreak:
            phase = .focus
        }

        secondsRemaining = phase.defaultDuration
        refreshPresentation()
    }

    private func refreshPresentation() {
        displayTime = Self.format(seconds: secondsRemaining)
        currentPhaseLabel = phase.rawValue
    }

    private static func format(seconds: Int) -> String {
        let safeSeconds = max(0, seconds)
        let minutes = safeSeconds / 60
        let remainingSeconds = safeSeconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}
