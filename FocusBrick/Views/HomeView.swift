import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: TimerViewModel
    @State private var showingSettings = false

    var body: some View {
        NavigationStack {
            VStack(spacing: FBSpacing.lg) {
                ZStack {
                    Circle()
                        .stroke(FBColors.secondary.opacity(0.2), lineWidth: 14)
                        .frame(width: 240, height: 240)

                    Circle()
                        .trim(from: 0, to: viewModel.progress)
                        .stroke(FBColors.primary, style: StrokeStyle(lineWidth: 14, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .frame(width: 240, height: 240)
                        .animation(.easeInOut(duration: 0.25), value: viewModel.progress)

                    VStack(spacing: FBSpacing.sm) {
                        Text(viewModel.currentPhaseLabel)
                            .font(FBTypography.body)
                            .foregroundColor(FBColors.secondary)

                        Text(viewModel.displayTime)
                            .font(FBTypography.timer)
                            .monospacedDigit()
                            .foregroundColor(FBColors.primary)
                    }
                }

                Text(viewModel.cycleProgressLabel)
                    .font(FBTypography.body)
                    .foregroundColor(FBColors.secondary)

                HStack(spacing: FBSpacing.md) {
                    Button(viewModel.isRunning ? "Pausar" : "Iniciar") {
                        viewModel.isRunning ? viewModel.pause() : viewModel.start()
                    }
                    .buttonStyle(.borderedProminent)

                    Button("Retomar") { viewModel.resume() }
                        .buttonStyle(.bordered)

                    Button("Reset") { viewModel.reset() }
                        .buttonStyle(.bordered)
                }

                Button("Pular fase") { viewModel.skip() }
                    .buttonStyle(.bordered)
            }
            .padding(FBSpacing.lg)
            .background(FBColors.background.ignoresSafeArea())
            .navigationTitle("Focus Brick")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Config") { showingSettings = true }
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView(viewModel: viewModel)
            }
        }
    }
}

struct SettingsView: View {
    @ObservedObject var viewModel: TimerViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var focus = "25"
    @State private var shortBreak = "5"
    @State private var longBreak = "15"
    @State private var cycle = "4"

    var body: some View {
        NavigationStack {
            Form {
                Section("Duração (min)") {
                    TextField("Foco", text: $focus).keyboardType(.numberPad)
                    TextField("Pausa", text: $shortBreak).keyboardType(.numberPad)
                    TextField("Pausa longa", text: $longBreak).keyboardType(.numberPad)
                }

                Section("Ciclo") {
                    TextField("Sessões para pausa longa", text: $cycle).keyboardType(.numberPad)
                }
            }
            .navigationTitle("Configurações")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Salvar") {
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
