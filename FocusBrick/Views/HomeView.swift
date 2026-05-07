import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: TimerViewModel
    @EnvironmentObject private var purchaseService: PurchaseService
    @State private var showingSettings = false
    @State private var showingPaywall = false
    @AppStorage("pro.theme.enabled") private var proThemeEnabled = false
    @AppStorage("pro.advanced.enabled") private var advancedCustomization = false

    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: FBSpacing.lg) {
                        ZStack {
                            Circle()
                                .stroke(FBColors.secondary.opacity(0.2), lineWidth: 14)
                                .frame(width: 240, height: 240)

                            Circle()
                                .trim(from: 0, to: viewModel.progress)
                                .stroke(proThemeEnabled ? .purple : FBColors.primary, style: StrokeStyle(lineWidth: 14, lineCap: .round))
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
                                    .foregroundColor(proThemeEnabled ? .purple : FBColors.primary)
                            }
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("Current session")
                        .accessibilityValue("\(viewModel.currentPhaseLabel). Remaining time \(viewModel.displayTime). \(viewModel.cycleProgressLabel)")

                        Text(viewModel.cycleProgressLabel)
                            .font(FBTypography.body)
                            .foregroundColor(FBColors.secondary)

                        HStack(spacing: FBSpacing.md) {
                            Button(viewModel.isRunning ? "Pause" : "Start") {
                                viewModel.isRunning ? viewModel.pause() : viewModel.start()
                            }
                            .buttonStyle(.borderedProminent)

                            Button("Resume") { viewModel.resume() }
                                .buttonStyle(.bordered)
                                .disabled(viewModel.isRunning)

                            Button("Reset") { viewModel.reset() }
                                .buttonStyle(.bordered)
                        }

                        Button("Skip phase") { viewModel.skip() }
                            .buttonStyle(.bordered)

                        VStack(alignment: .leading, spacing: FBSpacing.sm) {
                            Text("Today")
                                .font(FBTypography.title)
                                .foregroundColor(FBColors.primary)
                            Text("Completed sessions: \(viewModel.todayCompletedSessions)")
                            Text("Focused minutes: \(viewModel.todayFocusedMinutes)")
                            Text("Current streak: \(viewModel.dailyStreakDays) day(s)")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .id("daily-summary")

                        VStack(alignment: .leading, spacing: FBSpacing.sm) {
                            Text("History (7 days)")
                                .font(FBTypography.title)
                                .foregroundColor(FBColors.primary)

                            if viewModel.last7DaysRecords.isEmpty {
                                Text("No completed sessions yet.")
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
                                Text("Pro unlocked ✅")
                                    .foregroundColor(.green)
                            } else {
                                Text("Unlock extra themes and advanced customization.")
                                    .foregroundColor(FBColors.secondary)
                                Button("View Pro") { showingPaywall = true }
                                    .buttonStyle(.borderedProminent)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .id("current-session")
                    }
                    .padding(FBSpacing.lg)
                    .onChange(of: viewModel.deepLinkTarget) { _, target in
                        guard let target else { return }
                        withAnimation {
                            switch target {
                            case .currentSession: proxy.scrollTo("current-session", anchor: .top)
                            case .dailySummary: proxy.scrollTo("daily-summary", anchor: .top)
                            }
                        }
                        viewModel.deepLinkTarget = nil
                    }
                }
            }
            .background(FBColors.background.ignoresSafeArea())
            .navigationTitle("Focus Brick")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Settings") { showingSettings = true }
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView(
                    viewModel: viewModel,
                    proThemeEnabled: $proThemeEnabled,
                    advancedCustomization: $advancedCustomization
                )
                .environmentObject(purchaseService)
            }
            .sheet(isPresented: $showingPaywall) {
                PaywallView()
                    .environmentObject(purchaseService)
            }
        }
    }
}
