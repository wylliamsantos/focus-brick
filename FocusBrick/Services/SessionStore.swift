import Foundation

protocol SessionStore {
    func save(record: SessionRecord)
    func loadAll() -> [SessionRecord]
    func saveState(_ state: TimerSessionState)
    func loadState() -> TimerSessionState?
    func saveConfig(_ config: PomodoroConfig)
    func loadConfig() -> PomodoroConfig?
}

struct TimerSessionState: Codable, Equatable {
    let phase: SessionRecord.Phase
    let secondsRemaining: Int
    let completedFocusSessions: Int
    let isRunning: Bool
    let savedAt: Date
}

final class UserDefaultsSessionStore: SessionStore {
    private enum Keys {
        static let records = "focusbrick.session.records"
        static let state = "focusbrick.session.state"
        static let config = "focusbrick.session.config"
    }

    private let defaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func save(record: SessionRecord) {
        var records = loadAll()
        records.append(record)
        guard let data = try? encoder.encode(records) else { return }
        defaults.set(data, forKey: Keys.records)
    }

    func loadAll() -> [SessionRecord] {
        guard let data = defaults.data(forKey: Keys.records),
              let records = try? decoder.decode([SessionRecord].self, from: data) else {
            return []
        }
        return records
    }

    func saveState(_ state: TimerSessionState) {
        guard let data = try? encoder.encode(state) else { return }
        defaults.set(data, forKey: Keys.state)
    }

    func loadState() -> TimerSessionState? {
        guard let data = defaults.data(forKey: Keys.state),
              let state = try? decoder.decode(TimerSessionState.self, from: data) else {
            return nil
        }
        return state
    }

    func saveConfig(_ config: PomodoroConfig) {
        guard let data = try? encoder.encode(config) else { return }
        defaults.set(data, forKey: Keys.config)
    }

    func loadConfig() -> PomodoroConfig? {
        guard let data = defaults.data(forKey: Keys.config),
              let config = try? decoder.decode(PomodoroConfig.self, from: data) else {
            return nil
        }
        return config
    }
}
