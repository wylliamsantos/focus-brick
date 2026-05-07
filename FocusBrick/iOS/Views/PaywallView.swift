import SwiftUI

struct PaywallView: View {
    @EnvironmentObject private var purchaseService: PurchaseService
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: FBSpacing.lg) {
                Text("Focus Brick Pro")
                    .font(FBTypography.timer)
                    .multilineTextAlignment(.center)

                Text("One-time purchase to unlock extra themes and advanced customization.")
                    .font(FBTypography.body)
                    .foregroundColor(FBColors.secondary)
                    .multilineTextAlignment(.center)

                if purchaseService.hasProduct {
                    Button("Unlock for \(purchaseService.productPriceText)") {
                        Task { await purchaseService.buyPro() }
                    }
                    .buttonStyle(.borderedProminent)
                    .accessibilityHint("One-time purchase to unlock Pro features")
                } else if purchaseService.isLoading {
                    ProgressView("Loading options...")
                } else {
                    Text("Product unavailable at the moment.")
                        .foregroundColor(.secondary)
                }

                Button("Restore purchases") {
                    Task { await purchaseService.restorePurchases() }
                }
                .buttonStyle(.bordered)

                if purchaseService.isProUnlocked {
                    Text("Pro unlocked ✅")
                        .foregroundColor(.green)
                }

                Spacer()
            }
            .padding(FBSpacing.lg)
            .navigationTitle("Upgrade")
            .toolbar {
                ToolbarItem {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}
