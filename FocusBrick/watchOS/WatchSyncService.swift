import Foundation

#if canImport(WatchConnectivity)
import WatchConnectivity

@MainActor
final class WatchSyncService: NSObject, ObservableObject {
    @Published private(set) var latestState: WatchSessionState?

    private let session: WCSession?
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    override init() {
        self.session = WCSession.isSupported() ? .default : nil
        super.init()
        self.session?.delegate = self
        self.session?.activate()
    }

    func send(_ command: WatchControlCommand) {
        guard let session, session.isReachable,
              let data = try? encoder.encode(command) else { return }
        session.sendMessageData(data, replyHandler: nil, errorHandler: nil)
    }

    private func apply(data: Data) {
        guard let state = try? decoder.decode(WatchSessionState.self, from: data) else { return }
        latestState = state
    }
}

extension WatchSyncService: WCSessionDelegate {
    nonisolated func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}

    nonisolated func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        Task { @MainActor [weak self] in
            self?.apply(data: messageData)
        }
    }

    nonisolated func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        guard let data = applicationContext["watchSessionState"] as? Data else { return }
        Task { @MainActor [weak self] in
            self?.apply(data: data)
        }
    }
}

#else

@MainActor
final class WatchSyncService: ObservableObject {
    @Published private(set) var latestState: WatchSessionState?
    func send(_ command: WatchControlCommand) {}
}

#endif
