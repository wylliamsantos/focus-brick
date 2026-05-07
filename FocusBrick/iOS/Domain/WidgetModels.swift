import Foundation

struct SessionSnapshot: Codable, Equatable {
    let phaseLabel: String
    let displayTime: String
    let isRunning: Bool
    let todayCompletedSessions: Int
    let todayFocusedMinutes: Int
    let updatedAt: Date

    static let empty = SessionSnapshot(
        phaseLabel: "Foco",
        displayTime: "25:00",
        isRunning: false,
        todayCompletedSessions: 0,
        todayFocusedMinutes: 0,
        updatedAt: .now
    )
}
