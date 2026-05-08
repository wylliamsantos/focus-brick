import SwiftUI

struct WatchHomeView: View {
    @StateObject var viewModel: WatchTimerViewModel

    var body: some View {
        VStack(spacing: 8) {
            Text(viewModel.phaseLabel)
                .font(.headline)
            Text(viewModel.displayTime)
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .monospacedDigit()

            HStack {
                Button(viewModel.isRunning ? "Pausar" : "Start") {
                    viewModel.toggleRunPause()
                }
                .buttonStyle(.borderedProminent)

                Button("Reset") {
                    viewModel.reset()
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
    }
}

#Preview {
    WatchHomeView(viewModel: WatchTimerViewModel())
}
