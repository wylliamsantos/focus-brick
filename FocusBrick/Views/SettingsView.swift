import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: TimerViewModel
    @Binding var proThemeEnabled: Bool
    @Binding var advancedCustomization: Bool
    @EnvironmentObject private var purchaseService: PurchaseService
    @Environment(\.dismiss) private var dismiss

    @State private var focus = "25"
    @State private var shortBreak = "5"
    @State private var longBreak = "15"
    @State private var cycle = "4"

    var body: some View {
        NavigationStack {
            Form {
                Section("Duration (min)") {
                    TextField("Focus", text: $focus).keyboardType(.numberPad)
                    TextField("Short break", text: $shortBreak).keyboardType(.numberPad)
                    TextField("Long break", text: $longBreak).keyboardType(.numberPad)
                }

                Section("Cycle") {
                    TextField("Sessions before long break", text: $cycle).keyboardType(.numberPad)
                }

                Section("Pro Features") {
                    Toggle("Extra theme", isOn: $proThemeEnabled)
                        .disabled(!purchaseService.isProUnlocked)
                    Toggle("Advanced customization", isOn: $advancedCustomization)
                        .disabled(!purchaseService.isProUnlocked)
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let newConfig = PomodoroConfig(
                            focusMinutes: max(1, Int(focus) ?? 25),
                            shortBreakMinutes: max(1, Int(shortBreak) ?? 5),
                            longBreakMinutes: max(1, Int(longBreak) ?? 15),
                            sessionsBeforeLongBreak: max(1, Int(cycle) ?? 4)
                        )
                        viewModel.updateConfig(newConfig)
                        dismiss()
                    }
                }
            }
            .onAppear {
                focus = String(viewModel.config.focusMinutes)
                shortBreak = String(viewModel.config.shortBreakMinutes)
                longBreak = String(viewModel.config.longBreakMinutes)
                cycle = String(viewModel.config.sessionsBeforeLongBreak)
            }
        }
    }
}
