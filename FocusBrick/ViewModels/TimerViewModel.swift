import Foundation

@MainActor
final class TimerViewModel: ObservableObject {
    enum Phase: String {
        case focus = "Foco"
        case shortBreak = "Pausa"
        case longBreak = "Pausa Longa"

        var sessionPhase: SessionRecord.Phase {
            switch self {
            case .focus: return .focus
            case .shortBreak: return .shortBreak
            case .longBreak: return .longBreak
            }
        }
    }

    @Published private(set) var displayTime: String
    @Published private(set) var currentPhaseLabel: String
    @Published private(set) var phase: Phase
    @Published private(set) var isRunning: Bool = false
    @Published private(set) var cycleProgressLabel: String

    private let config: PomodoroConfig
    private var timer: Timer?
    private(set) var secondsRemaining: Int
    private var completedFocusSessions: Int = 0

    init(config: PomodoroConfig = .init()) {
        self.config = config
        self.phase = .focus
        self.secondsRemaining = config.focusMinutes * 60
        self.displayTime = Self.format(seconds: config.focusMinutes * 60)
        self.currentPhaseLabel = Phase.focus.rawValue
        self.cycleProgressLabel = "Ciclo 0/\(config.sessionsBeforeLongBreak)"
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
        secondsRemaining = duration(for: phase)
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
            phase = completedFocusSessions.isMultiple(of: config.sessionsBeforeLongBreak) ? .longBreak : .shortBreak
        case .shortBreak, .longBreak:
            phase = .focus
        }

        secondsRemaining = duration(for: phase)
        refreshPresentation()
    }

    private func duration(for phase: Phase) -> Int {
        switch phase {
        case .focus:
            return config.focusMinutes * 60
        case .shortBreak:
            return config.shortBreakMinutes * 60
        case .longBreak:
            return config.longBreakMinutes * 60
        }
    }

    private func refreshPresentation() {
        displayTime = Self.format(seconds: secondsRemaining)
        currentPhaseLabel = phase.rawValue
        cycleProgressLabel = "Ciclo \(completedFocusSessions % config.sessionsBeforeLongBreak)/\(config.sessionsBeforeLongBreak)"
    }

    private static func format(seconds: Int) -> String {
        let safeSeconds = max(0, seconds)
        let minutes = safeSeconds / 60
        let remainingSeconds = safeSeconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}
