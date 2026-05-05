import Foundation

final class TimerViewModel: ObservableObject {
    @Published var displayTime: String = "25:00"
    @Published var currentPhaseLabel: String = "Foco"
}
