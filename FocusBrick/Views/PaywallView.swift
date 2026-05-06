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

                Text("Compra única para desbloquear temas extras e customização avançada.")
                    .font(FBTypography.body)
                    .foregroundColor(FBColors.secondary)
                    .multilineTextAlignment(.center)

                if let product = purchaseService.product {
                    Button("Desbloquear por \(product.displayPrice)") {
                        Task { await purchaseService.buyPro() }
                    }
                    .buttonStyle(.borderedProminent)
                    .accessibilityHint("Compra única para liberar os recursos Pro")
                } else if purchaseService.isLoading {
                    ProgressView("Carregando opções...")
                } else {
                    Text("Produto indisponível no momento.")
                        .foregroundColor(.secondary)
                }

                Button("Restaurar compras") {
                    Task { await purchaseService.restorePurchases() }
                }
                .buttonStyle(.bordered)

                if purchaseService.isProUnlocked {
                    Text("Pro desbloqueado ✅")
                        .foregroundColor(.green)
                }

                Spacer()
            }
            .padding(FBSpacing.lg)
            .navigationTitle("Upgrade")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Fechar") { dismiss() }
                }
            }
        }
    }
}
