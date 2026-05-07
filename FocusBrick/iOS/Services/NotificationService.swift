import Foundation
import UserNotifications

protocol NotificationService {
    func requestAuthorizationIfNeeded()
    func schedulePhaseEndNotification(phaseName: String, in seconds: Int)
    func cancelPendingPhaseNotifications()
}

final class UserNotificationService: NotificationService {
    private let center: UNUserNotificationCenter

    init(center: UNUserNotificationCenter = .current()) {
        self.center = center
    }

    func requestAuthorizationIfNeeded() {
        center.requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }

    func schedulePhaseEndNotification(phaseName: String, in seconds: Int) {
        guard seconds > 0 else { return }
        let content = UNMutableNotificationContent()
        content.title = "Focus Brick"
        content.body = "\(phaseName) terminou. Bora pra próxima fase."
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(seconds), repeats: false)
        let request = UNNotificationRequest(identifier: "focusbrick.phase.end", content: content, trigger: trigger)
        center.add(request)
    }

    func cancelPendingPhaseNotifications() {
        center.removePendingNotificationRequests(withIdentifiers: ["focusbrick.phase.end"])
    }
}
