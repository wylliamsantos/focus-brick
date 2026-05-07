import Foundation

protocol WatchConnectivitySyncing: AnyObject {
    func activateIfNeeded()
    func send(state: WatchSessionState)
    var onCommand: ((WatchControlCommand) -> Void)? { get set }
}

#if canImport(WatchConnectivity)
import WatchConnectivity

final class WatchConnectivityService: NSObject, WatchConnectivitySyncing {
    static let shared = WatchConnectivityService()

    var onCommand: ((WatchControlCommand) -> Void)?

    private let session: WCSession?
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

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

        try? session.updateApplicationContext(payload)
    }
}

extension WatchConnectivityService: WCSessionDelegate {
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) { session.activate() }
    func sessionWatchStateDidChange(_ session: WCSession) {}

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}

    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        guard let command = try? decoder.decode(WatchControlCommand.self, from: messageData) else { return }
        DispatchQueue.main.async { [weak self] in
            self?.onCommand?(command)
        }
    }
}

#else

final class WatchConnectivityService: WatchConnectivitySyncing {
    static let shared = WatchConnectivityService()
    var onCommand: ((WatchControlCommand) -> Void)?
    func activateIfNeeded() {}
    func send(state: WatchSessionState) {}
}

#endif
