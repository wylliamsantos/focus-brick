import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: TimerViewModel
    @EnvironmentObject private var purchaseService: PurchaseService
    @State private var showingSettings = false
    @State private var showingPaywall = false

    var body: some View {
        NavigationStack {
            ScrollView {
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
                                .accessibilityAddTraits(.isHeader)

                            Text(viewModel.displayTime)
                                .font(FBTypography.timer)
                                .monospacedDigit()
                                .foregroundColor(FBColors.primary)
                                .accessibilityLabel("Tempo restante: \(viewModel.displayTime)")
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
                        .accessibilityLabel(viewModel.isRunning ? "Pausar timer" : "Iniciar timer")

                        Button("Retomar") { viewModel.resume() }
                            .buttonStyle(.bordered)
                            .disabled(viewModel.isRunning)
                            .accessibilityLabel("Retomar timer")

                        Button("Reset") { viewModel.reset() }
                            .buttonStyle(.bordered)
                            .accessibilityLabel("Resetar timer")
                    }

                    Button("Pular fase") { viewModel.skip() }
                        .buttonStyle(.bordered)
                        .accessibilityLabel("Pular fase atual")

                    VStack(alignment: .leading, spacing: FBSpacing.sm) {
                        Text("Hoje")
                            .font(FBTypography.title)
                            .foregroundColor(FBColors.primary)
                        Text("Sessões concluídas: \(viewModel.todayCompletedSessions)")
                        Text("Minutos focados: \(viewModel.todayFocusedMinutes)")
                        Text("Sequência atual: \(viewModel.dailyStreakDays) dia(s)")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                    VStack(alignment: .leading, spacing: FBSpacing.sm) {
                        Text("Histórico (7 dias)")
                            .font(FBTypography.title)
                            .foregroundColor(FBColors.primary)

                        if viewModel.last7DaysRecords.isEmpty {
                            Text("Sem sessões concluídas ainda.")
                                .foregroundColor(FBColors.secondary)
                        } else {
                            ForEach(viewModel.last7DaysRecords.prefix(12)) { record in
                                HStack {
                                    Text(record.endAt, style: .date)
                                    Spacer()
                                    Text("\(record.plannedMinutes) min")
                                }
                                .font(FBTypography.body)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                    VStack(alignment: .leading, spacing: FBSpacing.sm) {
                        Text("Focus Brick Pro")
                            .font(FBTypography.title)
                            .foregroundColor(FBColors.primary)

                        if purchaseService.isProUnlocked {
                            Text("Pro desbloqueado ✅")
                                .foregroundColor(.green)
                        } else {
                            Text("Desbloqueie temas extras e personalização avançada.")
                                .foregroundColor(FBColors.secondary)
                            Button("Ver Pro") { showingPaywall = true }
                                .buttonStyle(.borderedProminent)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(FBSpacing.lg)
            }
            .background(FBColors.background.ignoresSafeArea())
            .navigationTitle("Focus Brick")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Config") { showingSettings = true }
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView(viewModel: viewModel)
                    .environmentObject(purchaseService)
            }
            .sheet(isPresented: $showingPaywall) {
                PaywallView()
                    .environmentObject(purchaseService)
            }
        }
    }
}

struct SettingsView: View {
    @ObservedObject var viewModel: TimerViewModel
    @EnvironmentObject private var purchaseService: PurchaseService
    @Environment(\.dismiss) private var dismiss

    @State private var focus = "25"
    @State private var shortBreak = "5"
    @State private var longBreak = "15"
    @State private var cycle = "4"
    @State private var selectedPreset: Preset = .default255
    @State private var proThemeEnabled = false
    @State private var advancedCustomization = false

    enum Preset: String, CaseIterable, Identifiable {
        case default255 = "Padrão 25/5"
        case custom = "Custom"

        var id: String { rawValue }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Preset") {
                    Picker("Preset", selection: $selectedPreset) {
                        ForEach(Preset.allCases) { preset in
                            Text(preset.rawValue).tag(preset)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: selectedPreset) { _, newValue in
                        if newValue == .default255 {
                            focus = "25"
                            shortBreak = "5"
                            longBreak = "15"
                            cycle = "4"
                        }
                    }
                }

                Section("Duração (min)") {
                    TextField("Foco", text: $focus).keyboardType(.numberPad)
                    TextField("Pausa", text: $shortBreak).keyboardType(.numberPad)
                    TextField("Pausa longa", text: $longBreak).keyboardType(.numberPad)
                }

                Section("Ciclo") {
                    TextField("Sessões para pausa longa", text: $cycle).keyboardType(.numberPad)
                }

                Section("Recursos Pro") {
                    Toggle("Tema extra", isOn: $proThemeEnabled)
                        .disabled(!purchaseService.isProUnlocked)
                    Toggle("Customização avançada", isOn: $advancedCustomization)
                        .disabled(!purchaseService.isProUnlocked)

                    if !purchaseService.isProUnlocked {
                        Text("Desbloqueie o Pro para habilitar estes recursos.")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
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
                selectedPreset = (viewModel.config.focusMinutes == 25 && viewModel.config.shortBreakMinutes == 5 && viewModel.config.longBreakMinutes == 15 && viewModel.config.sessionsBeforeLongBreak == 4) ? .default255 : .custom
            }
            .onChange(of: focus) { _, _ in selectedPreset = .custom }
            .onChange(of: shortBreak) { _, _ in selectedPreset = .custom }
            .onChange(of: longBreak) { _, _ in selectedPreset = .custom }
            .onChange(of: cycle) { _, _ in selectedPreset = .custom }
        }
    }
}
