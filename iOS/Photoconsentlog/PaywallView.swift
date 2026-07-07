import SwiftUI

struct PaywallView: View {
    @EnvironmentObject var purchases: PurchaseManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            VStack(spacing: 24) {
                Spacer()
                Image(systemName: "star.circle.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(Theme.accent)
                Text("Family Photo Consent Log Pro")
                    .font(Theme.titleFont)
                    .foregroundStyle(Theme.textPrimary)
                Text("Shared-photo audit export and reminder to review old posts")
                    .font(Theme.bodyFont)
                    .foregroundStyle(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                if let product = purchases.product {
                    Button {
                        Task { await purchases.purchase() }
                    } label: {
                        Text("Unlock for \(product.displayPrice)/month")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.accent)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .accessibilityIdentifier("paywallPurchaseButton")
                    .padding(.horizontal, 32)
                } else {
                    ProgressView()
                }

                Button("Restore Purchases") {
                    Task { await purchases.restore() }
                }
                .font(.footnote)
                .foregroundStyle(Theme.textSecondary)
                .accessibilityIdentifier("restorePurchasesButton")

                Spacer()
                Button("Not Now") { dismiss() }
                    .foregroundStyle(Theme.textSecondary)
                    .accessibilityIdentifier("paywallDismissButton")
                    .padding(.bottom, 24)
            }
        }
        .task { await purchases.load() }
    }
}
