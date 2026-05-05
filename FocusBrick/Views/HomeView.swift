import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: TimerViewModel

    var body: some View {
        VStack(spacing: FBSpacing.lg) {
            Text("Focus Brick")
                .font(FBTypography.title)
                .foregroundColor(FBColors.primary)

            Text(viewModel.displayTime)
                .font(FBTypography.timer)
                .monospacedDigit()

            Text(viewModel.currentPhaseLabel)
                .font(FBTypography.body)
                .foregroundColor(FBColors.secondary)

            Text(viewModel.cycleProgressLabel)
                .font(FBTypography.body)
                .foregroundColor(FBColors.secondary)

            HStack(spacing: FBSpacing.md) {
                Button(viewModel.isRunning ? "Pausar" : "Iniciar") {
                    viewModel.isRunning ? viewModel.pause() : viewModel.start()
                }
                .buttonStyle(.borderedProminent)

                Button("Retomar") {
                    viewModel.resume()
                }
                .buttonStyle(.bordered)

                Button("Reset") {
                    viewModel.reset()
                }
                .buttonStyle(.bordered)
            }

            Button("Pular fase") {
                viewModel.skip()
            }
            .buttonStyle(.bordered)
        }
        .padding(FBSpacing.lg)
        .background(FBColors.background.ignoresSafeArea())
    }
}
