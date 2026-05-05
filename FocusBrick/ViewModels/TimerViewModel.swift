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

        init(sessionPhase: SessionRecord.Phase) {
            switch sessionPhase {
            case .focus: self = .focus
            case .shortBreak: self = .shortBreak
            case .longBreak: self = .longBreak
            }
        }
    }

    @Published private(set) var displayTime: String
    @Published private(set) var currentPhaseLabel: String
    @Published private(set) var phase: Phase
    @Published private(set) var isRunning: Bool = false
    @Published private(set) var cycleProgressLabel: String
    @Published private(set) var progress: Double = 1
    @Published var config: PomodoroConfig

    private let store: SessionStore
    private var timer: Timer?
    private(set) var secondsRemaining: Int
    private var completedFocusSessions: Int = 0
    private var phaseStartedAt: Date = .now

    init(config: PomodoroConfig = .init(), store: SessionStore = UserDefaultsSessionStore()) {
        self.config = config
        self.store = store

        if let state = store.loadState() {
            let restoredPhase = Phase(sessionPhase: state.phase)
            self.phase = restoredPhase
            self.secondsRemaining = state.secondsRemaining
            self.completedFocusSessions = state.completedFocusSessions
            self.isRunning = state.isRunning
            self.displayTime = Self.format(seconds: state.secondsRemaining)
            self.currentPhaseLabel = restoredPhase.rawValue
            self.cycleProgressLabel = "Ciclo \(state.completedFocusSessions % max(1, config.sessionsBeforeLongBreak))/\(max(1, config.sessionsBeforeLongBreak))"
            self.progress = Self.computeProgress(remaining: state.secondsRemaining, total: Self.duration(for: restoredPhase, config: config))
        } else {
            self.phase = .focus
            self.secondsRemaining = config.focusMinutes * 60
            self.displayTime = Self.format(seconds: config.focusMinutes * 60)
            self.currentPhaseLabel = Phase.focus.rawValue
            self.cycleProgressLabel = "Ciclo 0/\(max(1, config.sessionsBeforeLongBreak))"
        }

        if isRunning { startTicker() }
    }

    deinit { timer?.invalidate() }

    func start() {
        guard !isRunning else { return }
        phaseStartedAt = .now
        isRunning = true
        persistState()
        startTicker()
    }

    func pause() {
        guard isRunning else { return }
        isRunning = false
        timer?.invalidate()
        timer = nil
        persistState()
    }

    func resume() { start() }

    func reset() {
        pause()
        secondsRemaining = duration(for: phase)
        phaseStartedAt = .now
        refreshPresentation()
        persistState()
    }

    func skip() {
        pause()
        completeCurrentPhaseAndAdvance(completed: false)
    }

    func updateConfig(_ config: PomodoroConfig) {
        self.config = config
        reset()
    }

    private func startTicker() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            Task { @MainActor in self.tick() }
        }
    }

    private func tick() {
        guard isRunning else { return }
        if secondsRemaining > 0 { secondsRemaining -= 1; refreshPresentation(); persistState() }
        if secondsRemaining == 0 {
            completeCurrentPhaseAndAdvance(completed: true)
            if isRunning { startTicker() }
        }
    }

    private func completeCurrentPhaseAndAdvance(completed: Bool) {
        let endedPhase = phase
        let plannedMinutes = duration(for: endedPhase) / 60
        if completed {
            let record = SessionRecord(id: UUID(), startAt: phaseStartedAt, endAt: .now, phase: endedPhase.sessionPhase, plannedMinutes: plannedMinutes, completed: true)
            store.save(record: record)
        }

        switch phase {
        case .focus:
            completedFocusSessions += 1
            phase = completedFocusSessions.isMultiple(of: max(1, config.sessionsBeforeLongBreak)) ? .longBreak : .shortBreak
        case .shortBreak, .longBreak:
            phase = .focus
        }

        secondsRemaining = duration(for: phase)
        phaseStartedAt = .now
        refreshPresentation()
        persistState()
    }

    private func duration(for phase: Phase) -> Int { Self.duration(for: phase, config: config) }

    private static func duration(for phase: Phase, config: PomodoroConfig) -> Int {
        switch phase {
        case .focus: return config.focusMinutes * 60
        case .shortBreak: return config.shortBreakMinutes * 60
        case .longBreak: return config.longBreakMinutes * 60
        }
    }

    private func refreshPresentation() {
        displayTime = Self.format(seconds: secondsRemaining)
        currentPhaseLabel = phase.rawValue
        cycleProgressLabel = "Ciclo \(completedFocusSessions % max(1, config.sessionsBeforeLongBreak))/\(max(1, config.sessionsBeforeLongBreak))"
        progress = Self.computeProgress(remaining: secondsRemaining, total: duration(for: phase))
    }

    private func persistState() {
        let state = TimerSessionState(phase: phase.sessionPhase, secondsRemaining: secondsRemaining, completedFocusSessions: completedFocusSessions, isRunning: isRunning, savedAt: .now)
        store.saveState(state)
    }

    private static func computeProgress(remaining: Int, total: Int) -> Double {
        guard total > 0 else { return 0 }
        return min(1, max(0, Double(total - remaining) / Double(total)))
    }

    private static func format(seconds: Int) -> String {
        let safeSeconds = max(0, seconds)
        return String(format: "%02d:%02d", safeSeconds / 60, safeSeconds % 60)
    }
}
