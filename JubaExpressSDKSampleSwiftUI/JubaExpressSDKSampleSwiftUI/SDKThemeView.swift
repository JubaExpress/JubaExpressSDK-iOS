//
//  SDKThemeView.swift
//  Juba Express Money Transfer
//
//  Step 2 of 2 — collects all 9 SDK theme colours then launches the SDK.
//

import SwiftUI
import JubaExpressSDK
import Combine

// MARK: - Theme View Model

final class SDKThemeViewModel: NSObject, ObservableObject, JESDKDelegate {

    // Injected
    let subscriptionKey: String
    let partnerKey:      String
    let environment:     JESDKBuildEnvironment
    let baseURL:         String
    let referenceId:     String?

    // Mutable theme — each @Published drives a ColorPicker in the UI
    @Published var theme = SDKTheme()

    // Remittance result alert
    @Published var remittanceMessage: String?
    @Published var showRemittance = false

    init(subscriptionKey: String, partnerKey: String, environment: JESDKBuildEnvironment, baseURL: String, referenceId: String? = nil) {
        self.subscriptionKey = subscriptionKey
        self.partnerKey      = partnerKey
        self.environment     = environment
        self.baseURL         = baseURL
        self.referenceId     = referenceId
    }

    func launchSDK() {
        let sdk = PaymentSDK()
        let config = sdk.getConfiguration(
            subscriptionKey: subscriptionKey,
            partnerKey:      partnerKey,
            environment:     environment,
            baseURL:         baseURL,
            referenceId:     referenceId
        )
        sdk.applyThemeAndStart(configuration: config, theme: theme, delegate: self)
    }

    // MARK: JESDKDelegate
    func JESDKSecretKey(payment: Payment) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.remittanceMessage = """
            Reference ID:    \(payment.referenceId    ?? "N/A")
            Secret Key:      \(payment.secretkey       ?? "N/A")

            Sender Amount:   \(payment.SentAmount      ?? 0.0) \(payment.currencyCode ?? "")
            Total Sent:      \(payment.totalSentAmount  ?? 0.0)
            Commission:      \(payment.CommissionAmount ?? 0.0)

            Beneficiary:     \(payment.BeneficiaryName   ?? "N/A")
            Mobile:          \(payment.BeneficiaryMobile ?? "N/A")
            Account:         \(payment.AccountNo          ?? "N/A")

            Destination:     \(payment.DestinationCountry     ?? "N/A")
            Country Code:    \(payment.DestinationCountryCode ?? "N/A")

            Payment Mode:    \(payment.PaymentMode     ?? "N/A")
            Pay Currency:    \(payment.PayCurrencyCode  ?? "N/A")
            Payout Amount:   \(payment.PayoutAmount     ?? 0.0)

            Source of Funds: \(payment.SourceOfFunds           ?? "N/A")
            Purpose:         \(payment.Purpose                  ?? "N/A")
            Relationship:    \(payment.BeneficiaryRelationship  ?? "N/A")
            """
            self.showRemittance = true
        }
    }
}

// MARK: - SDKThemeView

struct SDKThemeView: View {

    @StateObject private var vm: SDKThemeViewModel

    init(subscriptionKey: String, partnerKey: String, environment: JESDKBuildEnvironment, baseURL: String, referenceId: String? = nil) {
        _vm = StateObject(wrappedValue: SDKThemeViewModel(
            subscriptionKey: subscriptionKey,
            partnerKey:      partnerKey,
            environment:     environment,
            baseURL:         baseURL,
            referenceId:     referenceId
        ))
    }

    // Each entry: (label, keyPath into SDKTheme)
    private let colorRows: [(String, WritableKeyPath<SDKTheme, Color>)] = [
        ("Primary",                      \.primary),
        ("Secondary",                    \.secondary),
        ("Tertiary",                     \.tertiary),
        ("Field Background",             \.fieldBackground),
        ("Top Heading",                  \.topHeading),
        ("Button Background",            \.buttonBackground),
        ("Button Text",                  \.buttonText),
        ("Transfer Button Background",   \.transferButtonBackground),
        ("Transfer Button Text",         \.transferButtonText),
    ]

    var body: some View {
        List {
            Section(header: Text("Tap a swatch to change its colour")) {
                ForEach(colorRows, id: \.0) { label, keyPath in
                    colorPickerRow(label: label, keyPath: keyPath)
                }
            }

            Section {
                launchButton
            }
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets())
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Customize Theme")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Remittance Details",
               isPresented: $vm.showRemittance,
               actions: { Button("OK", role: .cancel) {} },
               message: { Text(vm.remittanceMessage ?? "") })
    }

    // MARK: - Row builder

    private func colorPickerRow(label: String,
                                keyPath: WritableKeyPath<SDKTheme, Color>) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 15))

            Spacer()

            // Native SwiftUI ColorPicker — shows swatch + opens picker on tap
            ColorPicker("", selection: Binding(
                get: { vm.theme[keyPath: keyPath] },
                set: { vm.theme[keyPath: keyPath] = $0 }
            ))
            .labelsHidden()
            .frame(width: 32, height: 32)
        }
        .frame(height: 52)
    }

    // MARK: - Launch button

    private var launchButton: some View {
        Button {
            vm.launchSDK()
        } label: {
            HStack {
                Image(systemName: "arrow.right.circle.fill")
                Text("Launch Payment SDK")
                    .fontWeight(.semibold)
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(Color.green)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .padding(.horizontal, 4)
        }
    }
}

#Preview {
    NavigationStack {
        SDKThemeView(subscriptionKey: "test-sub", partnerKey: "test-partner", environment: .UAT, baseURL: "https://online.jubaexpress.net/JubaExpressSDKAPIs/", referenceId: nil)
    }
}
