//
//  ConfigurationView.swift
//  Juba Express Money Transfer
//
//  Step 1 of 2 — collects SubscriptionKey, PartnerKey, ReferenceID (optional)
//  Environment is always UAT
//

import SwiftUI
import JubaExpressSDK

struct ConfigurationView: View {

    @State private var subscriptionKey: String = ""
    @State private var partnerKey:      String = ""
    @State private var referenceId:     String = ""
    @State private var baseURL:         String = ""   // optional — overrides uatBaseURL if filled
    @State private var showValidation:  Bool   = false
    @State private var navigateToTheme: Bool   = false
    @State private var navigateToDemo:  Bool   = false

    // ── Hardcoded UAT credentials ─────────────────────────────────────────────
    private let uatBaseURL          = "YOUR_DEMO_BASE_URL"
    private let demoSubscriptionKey = "YOUR_DEMO_SUBSCRIPTION_KEY"
    private let demoPartnerKey      = "YOUR_DEMO_PARTNER_KEY"

    // Resolved base URL: user input wins if provided, otherwise fall back to hardcoded
    private var resolvedBaseURL: String {
        baseURL.trimmed.isEmpty ? uatBaseURL : baseURL.trimmed
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 28) {
                    logoSection
                    keysCard
                    nextButton
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 28)
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("SDK Configuration")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $navigateToTheme) {
                SDKThemeView(
                    subscriptionKey: subscriptionKey.trimmed,
                    partnerKey:      partnerKey.trimmed,
                    environment:     .UAT,
                    baseURL:         resolvedBaseURL,
                    referenceId:     referenceId.trimmed.isEmpty ? nil : referenceId.trimmed
                )
            }
            .navigationDestination(isPresented: $navigateToDemo) {
                SDKThemeView(
                    subscriptionKey: demoSubscriptionKey,
                    partnerKey:      demoPartnerKey,
                    environment:     .UAT,
                    baseURL:         uatBaseURL,
                    referenceId:     nil
                )
            }
            .alert("Missing Fields",
                   isPresented: $showValidation,
                   actions: { Button("OK", role: .cancel) {} },
                   message: { Text("Please fill in both Subscription Key and Partner Key.") })
        }
    }

    // MARK: - Logo

    private var logoSection: some View {
        Image("AppLogo")
            .resizable()
            .scaledToFit()
            .frame(width: 110, height: 110)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    // MARK: - Keys card

    private var keysCard: some View {
        VStack(spacing: 0) {
            clearableField(icon: "key.fill",
                           placeholder: "Subscription Key",
                           text: $subscriptionKey)

            Divider().padding(.leading, 48)

            clearableField(icon: "person.badge.key.fill",
                           placeholder: "Partner Key",
                           text: $partnerKey)

            Divider().padding(.leading, 48)

            clearableField(icon: "globe",
                           placeholder: "Base URL",
                           text: $baseURL,
                           isOptional: true)

            Divider().padding(.leading, 48)

            clearableField(icon: "number.circle",
                           placeholder: "Transaction Reference ID",
                           text: $referenceId,
                           isOptional: true)
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.07), radius: 16, x: 0, y: 4)
    }

    // MARK: - Clearable field row

    @ViewBuilder
    private func clearableField(icon: String,
                                placeholder: String,
                                text: Binding<String>,
                                isOptional: Bool = false) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(isOptional ? Color(.tertiaryLabel) : .secondary)
                .frame(width: 20)

            TextField(placeholder, text: text)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .keyboardType(icon == "globe" ? .URL : .default)
                .foregroundColor(isOptional ? Color(.secondaryLabel) : .primary)

            if isOptional && text.wrappedValue.isEmpty {
                Text("Optional")
                    .font(.caption)
                    .foregroundColor(Color(.tertiaryLabel))
                    .transition(.opacity.animation(.easeInOut(duration: 0.15)))
            }

            if !text.wrappedValue.isEmpty {
                Button {
                    text.wrappedValue = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color(.tertiaryLabel))
                        .font(.system(size: 16))
                }
                .buttonStyle(.plain)
                .transition(.opacity.animation(.easeInOut(duration: 0.15)))
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 56)
        .animation(.easeInOut(duration: 0.15), value: text.wrappedValue.isEmpty)
    }

    // MARK: - Buttons

    private var nextButton: some View {
        VStack(spacing: 0) {
            Button {
                guard !subscriptionKey.trimmed.isEmpty,
                      !partnerKey.trimmed.isEmpty else {
                    showValidation = true
                    return
                }
                navigateToTheme = true
            } label: {
                HStack {
                    Text("Next: Customize Theme")
                    Image(systemName: "arrow.right")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }

            // OR divider
            HStack {
                Rectangle()
                    .frame(height: 0.5)
                    .foregroundColor(Color(.separator))
                Text("OR")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(Color(.tertiaryLabel))
                    .padding(.horizontal, 8)
                Rectangle()
                    .frame(height: 0.5)
                    .foregroundColor(Color(.separator))
            }
            .padding(.vertical, 20)

            // Explore Demo
            Button {
                navigateToDemo = true
            } label: {
                HStack {
                    Image(systemName: "sparkles")
                    Text("Explore Demo Application")
                }
                .font(.headline)
                .foregroundColor(.blue)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Color.blue, lineWidth: 1.5)
                )
            }
        }
    }
}

// MARK: - String helper
private extension String {
    var trimmed: String { trimmingCharacters(in: .whitespaces) }
}

#Preview {
    ConfigurationView()
}
