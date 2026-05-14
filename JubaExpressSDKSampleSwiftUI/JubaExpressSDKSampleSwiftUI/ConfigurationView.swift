//
//  ConfigurationView.swift
//  Juba Express Money Transfer
//
//  Step 1 of 2 — collects SubscriptionKey, PartnerKey, ReferenceID (optional), Environment
//

import SwiftUI
import JubaExpressSDK

struct ConfigurationView: View {

    @State private var subscriptionKey: String = ""
    @State private var partnerKey:      String = ""
    @State private var referenceId:     String = ""
    @State private var baseURL:         String = ""
    @State private var selectedEnv:     Int    = 1       // default UAT
    @State private var showValidation:  Bool   = false
    @State private var showBaseURLAlert: Bool   = false
    @State private var navigateToTheme: Bool   = false
    @State private var navigateToDemo:  Bool   = false

    private let environments = ["Production", "Test (UAT)"]

    // ── Demo credentials — replace with your real keys ────────────────────────
    private let uatBaseURL          = "YOUR_DEMO_BASE_URL"
    private let demoSubscriptionKey = "YOUR_DEMO_SUBSCRIPTION_KEY"
    private let demoPartnerKey      = "YOUR_DEMO_PARTNER_KEY"

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 28) {
                    logoSection
                    environmentSection
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
                    environment:     selectedEnv == 0 ? .Live : .UAT,
                    baseURL:         selectedEnv == 0 ? baseURL.trimmed : uatBaseURL,
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
            .alert("Base URL Required",
                   isPresented: $showBaseURLAlert,
                   actions: { Button("OK", role: .cancel) {} },
                   message: { Text("Please enter the Base URL for the Production environment.") })
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

    // MARK: - Environment section

    private var environmentSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Environment")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
                .padding(.leading, 4)

            Picker("Environment", selection: $selectedEnv) {
                ForEach(environments.indices, id: \.self) { i in
                    Text(environments[i]).tag(i)
                }
            }
            .pickerStyle(.segmented)
        }
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

            // Base URL — only visible when Production is selected
            if selectedEnv == 0 {
                clearableField(icon: "globe",
                               placeholder: "Base URL (Production)",
                               text: $baseURL)
                Divider().padding(.leading, 48)
            }

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
            // Next: Customize Theme
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

            // Explore Demo Application
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

struct CustomSegmentedControl: View {

    let items: [String]
    @Binding var selectedIndex: Int

    @Namespace private var animation

    var body: some View {
        HStack(spacing: 4) {
            ForEach(items.indices, id: \.self) { i in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedIndex = i
                    }
                } label: {
                    Text(items[i])
                        .font(.system(size: 15, weight: selectedIndex == i ? .semibold : .regular))
                        .foregroundColor(selectedIndex == i ? .primary : .secondary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background {
                            if selectedIndex == i {
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(Color(.systemBackground))
                                    .shadow(color: .black.opacity(0.12), radius: 4, x: 0, y: 2)
                                    .matchedGeometryEffect(id: "segment", in: animation)
                            }
                        }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(Color(.systemGray5))
        .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
    }
}

// MARK: - String helper
private extension String {
    var trimmed: String { trimmingCharacters(in: .whitespaces) }
}

#Preview {
    ConfigurationView()
}
