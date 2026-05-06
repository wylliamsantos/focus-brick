import Foundation
import WatchConnectivity

protocol WatchConnectivitySyncing {
    func activateIfNeeded()
    func send(state: WatchSessionState)
}

final class WatchConnectivityService: NSObject, WatchConnectivitySyncing {
    static let shared = WatchConnectivityService()

    private let session: WCSession?
    private let encoder = JSONEncoder()

    init(session: WCSession? = WCSession.isSupported() ? .default : nil) {
        self.session = session
        super.init()
        self.session?.delegate = self
    }

    func activateIfNeeded() {
        guard let session else { return }
        guard session.activationState != .activated else { return }
        session.activate()
    }

    func send(state: WatchSessionState) {
        guard let session, session.isPaired, session.isWatchAppInstalled else { return }
        guard let payloadData = try? encoder.encode(state) else { return }

        let payload: [String: Any] = [
            "watchSessionState": payloadData,
            "updatedAt": state.updatedAt.timeIntervalSince1970
        ]

        if session.isReachable {
            session.sendMessageData(payloadData, replyHandler: nil, errorHandler: nil)
        }

        do {
            try session.updateApplicationContext(payload)
        } catch {
            // noop: best effort sync
        }
    }
}

extension WatchConnectivityService: WCSessionDelegate {
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) { session.activate() }
    func sessionWatchStateDidChange(_ session: WCSession) {}

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
}
