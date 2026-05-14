//
//  PaymentSDK.swift
//  Juba Express Money Transfer
//

import SwiftUI
import JubaExpressSDK

// MARK: - PaymentSDK

public class PaymentSDK {

    public init() {}

    func getConfiguration(subscriptionKey: String,
                          partnerKey: String,
                          environment: JESDKBuildEnvironment,
                          referenceId: String? = nil) -> JESDKConfiguration {

        let customerDocument = JESSDKCustomerDocument(
            DocumentType:           "0",
            DocumentNumber:         RandomCustomer.documentNumber,
            DocumentIssueDate:      "19/01/2023",
            DocumentExpiryDate:     "19/01/2033",
            DocumentIssuingCountry: ""
        )

        let customerName = JESSDKCustomerName(
            FirstName:  "John",
            MiddleName: "",
            LastName:   "Doe"
        )

        let customerInfo = JESSDKCustomerInfo(
            name:         customerName,
            CIF:          RandomCustomer.cif(subscriptionKey: subscriptionKey, partnerKey: partnerKey),
            mobile:       RandomCustomer.mobile,
            email:        RandomCustomer.email,
            nationality:  "XYZ",
            DateOfBirth:  "29/06/1983",
            PlaceOfBirth: "XYZ",
            Gender:       "0",
            Document:     customerDocument
        )

        return JESDKConfiguration(
            BaseURL:                  baseURL,
            SubscriptionKey:          subscriptionKey,
            PartnerKey:               partnerKey,
            referenceid:              referenceId,
            customerInfo:             customerInfo,
            enviroment:               environment,
            IsViewTransactionHistory: false
        )
    }

    func applyThemeAndStart(configuration: JESDKConfiguration,
                            theme: SDKTheme,
                            delegate: JESDKDelegate) {

        JESDK.setPrimaryColor(UIColor(theme.primary))
        JESDK.setSecondaryColor(UIColor(theme.secondary))
        JESDK.setTertionaryColor(UIColor(theme.tertiary))
        JESDK.setBackgroundColor(UIColor(theme.fieldBackground))
        JESDK.setTopHeadingColor(UIColor(theme.topHeading))
        JESDK.setButtonBackgroundColor(UIColor(theme.buttonBackground))
        JESDK.setButtonTextColor(UIColor(theme.buttonText))
        JESDK.setStartTransferButtonBackgroundColor(UIColor(theme.transferButtonBackground))
        JESDK.setStartTransferButtonTextColor(UIColor(theme.transferButtonText))
        JESDK.setCreateRemittanceText("Create Remittance")
        JESDK.setStartTransfeText("Start Transfer")

        JESDK.initSDK(configuration: configuration)
        JESDK.sharedInstance()?.delegate = delegate
    }
}

// MARK: - Random Customer Info Generator

private struct RandomCustomer {

    // CIF — one unique CIF per subscriptionKey+partnerKey pair, persisted forever.
    // Each unique pair gets its own CIF stored in a dictionary — old pairs are never overwritten.
    static func cif(subscriptionKey: String, partnerKey: String) -> String {
        let dictKey  = "je_cif_map"
        let pairKey  = "\(subscriptionKey)__\(partnerKey)"
        let defaults = UserDefaults.standard

        var cifMap = defaults.dictionary(forKey: dictKey) as? [String: String] ?? [:]

        if let existingCIF = cifMap[pairKey] {
            return existingCIF
        }

        let newCIF = (0..<14).map { _ in String(Int.random(in: 0...9)) }.joined()
        cifMap[pairKey] = newCIF
        defaults.set(cifMap, forKey: dictKey)
        return newCIF
    }

    // Random mobile with UK prefix
    static var mobile: String {
        let number = (0..<10).map { _ in String(Int.random(in: 0...9)) }.joined()
        return "+44\(number)"
    }

    // Random email using UUID prefix
    static var email: String {
        let prefix  = UUID().uuidString.prefix(8).lowercased()
        let domains = ["demo.com", "test.com", "showcase.net", "partner.io"]
        return "\(prefix)@\(domains.randomElement()!)"
    }

    static var documentNumber: String {
        (0..<14).map { _ in String(Int.random(in: 0...9)) }.joined()
    }
}
