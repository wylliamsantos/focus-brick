import Foundation
import Combine
import StoreKit

@MainActor
final class PurchaseService: ObservableObject {
    @Published private(set) var product: Product?
    @Published private(set) var isProUnlocked: Bool = false
    @Published private(set) var isLoading: Bool = false

    let productID = "focusbrick.pro.lifetime"
    private let unlockKey = "focusbrick.pro.unlocked"

    init() {
        isProUnlocked = UserDefaults.standard.bool(forKey: unlockKey)
        Task {
            await loadProducts()
            await refreshEntitlements()
        }
    }

    func loadProducts() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let products = try await Product.products(for: [productID])
            product = products.first
        } catch {
            product = nil
        }
    }

    func buyPro() async {
        guard let product else { return }
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                if case .verified(let transaction) = verification {
                    await transaction.finish()
                    unlockPro()
                }
            case .userCancelled, .pending:
                break
            @unknown default:
                break
            }
        } catch {
            return
        }
    }

    func restorePurchases() async {
        do {
            try await AppStore.sync()
            await refreshEntitlements()
        } catch {
            return
        }
    }

    func refreshEntitlements() async {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else { continue }
            if transaction.productID == productID {
                unlockPro()
                return
            }
        }
    }

    private func unlockPro() {
        isProUnlocked = true
        UserDefaults.standard.set(true, forKey: unlockKey)
    }
}
