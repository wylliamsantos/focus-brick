import Foundation

struct WatchSessionState: Codable, Equatable {
    let phaseLabel: String
    let displayTime: String
    let isRunning: Bool
    let secondsRemaining: Int
    let completedFocusSessions: Int
    let todayCompletedSessions: Int
    let todayFocusedMinutes: Int
    let updatedAt: Date
}

enum WatchControlCommand: String, Codable {
    case toggleRunPause
    case reset
}

extension WatchSessionState {
    init(from timerState: TimerSessionState, snapshot: SessionSnapshot) {
        self.phaseLabel = snapshot.phaseLabel
        self.displayTime = snapshot.displayTime
        self.isRunning = snapshot.isRunning
        self.secondsRemaining = timerState.secondsRemaining
        self.completedFocusSessions = timerState.completedFocusSessions
        self.todayCompletedSessions = snapshot.todayCompletedSessions
        self.todayFocusedMinutes = snapshot.todayFocusedMinutes
        self.updatedAt = snapshot.updatedAt
    }
}
