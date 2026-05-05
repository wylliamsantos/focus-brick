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
        }
        .padding(FBSpacing.lg)
        .background(FBColors.background.ignoresSafeArea())
    }
}
