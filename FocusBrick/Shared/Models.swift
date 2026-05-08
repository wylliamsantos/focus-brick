import Foundation

struct PomodoroConfig: Codable, Equatable {
    var focusMinutes: Int = 25
    var shortBreakMinutes: Int = 5
    var longBreakMinutes: Int = 15
    var sessionsBeforeLongBreak: Int = 4
}

struct SessionRecord: Codable, Identifiable, Equatable {
    let id: UUID
    let startAt: Date
    let endAt: Date
    let phase: Phase
    let plannedMinutes: Int
    let completed: Bool

    enum Phase: String, Codable {
        case focus
        case shortBreak
        case longBreak
    }
}

struct DailySummary: Codable, Equatable {
    let day: Date
    var completedSessions: Int
    var focusedMinutes: Int
}
