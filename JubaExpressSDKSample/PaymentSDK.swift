//
//  PaymentSDK.swift
//  Juba Express Money Transfer
//

import Foundation
import UIKit
import JubaExpressSDK

// MARK: - PaymentSDK

public class PaymentSDK {

    public init() {}

    func getConfiguration(subscriptionKey: String,
                          partnerKey: String,
                          environment: JESDKBuildEnvironment,
                          baseURL: String,
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
            mobile:       RandomCustomer.mobile,   // random each call
            email:        RandomCustomer.email,    // random each call
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

        JESDK.setPrimaryColor(theme.primary)
        JESDK.setSecondaryColor(theme.secondary)
        JESDK.setTertionaryColor(theme.tertiary)
        JESDK.setBackgroundColor(theme.fieldBackground)
        JESDK.setTopHeadingColor(theme.topHeading)
        JESDK.setButtonBackgroundColor(theme.buttonBackground)
        JESDK.setButtonTextColor(theme.buttonText)
        JESDK.setStartTransferButtonBackgroundColor(theme.transferButtonBackground)
        JESDK.setStartTransferButtonTextColor(theme.transferButtonText)
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

        // Load existing map (or start fresh)
        var cifMap = defaults.dictionary(forKey: dictKey) as? [String: String] ?? [:]

        // Return existing CIF for this pair if already saved
        if let existingCIF = cifMap[pairKey] {
            return existingCIF
        }

        // New pair — generate a fresh CIF and store it alongside all previous pairs
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
        let prefix = UUID().uuidString.prefix(8).lowercased()
        let domains = ["demo.com", "test.com", "showcase.net", "partner.io"]
        return "\(prefix)@\(domains.randomElement()!)"
    }

    static var documentNumber: String {
        (0..<14).map { _ in String(Int.random(in: 0...9)) }.joined()
    }
}
