//
//  StartSDK.swift
//  Juba Express Money Transfer
//
//  Created by JubaExpressSDK on 20/05/2023.
//

import Foundation
import JubaExpressSDK


public class PaymentSDK {
    
    public init() {}
    
    public func getConfiguration(referenceId: String? = nil) -> JESDKConfiguration {
        
        
        let customerDocument = JESSDKCustomerDocument(DocumentType: "0" , DocumentNumber: "<Customer Document Nubmber>", DocumentIssueDate:"<Customer Document Issue Date format DD/MM/YYYY>", DocumentExpiryDate: "<Customer Document Expiry Date format DD/MM/YYYY>", DocumentIssuingCountry: "")
        
        let customerName = JESSDKCustomerName(FirstName:  "<Customer first name>", MiddleName: "", LastName: "<Customer Last name>")
        
        let customerInfo = JESSDKCustomerInfo(name: customerName, CIF: "<Your CIF>", mobile: "<Customer registered mobile mumber>", email: "<Customer registered email address>", nationality: "<Customer nationality>", DateOfBirth:"<Customer Dob format DD/MM/YYYY>",  PlaceOfBirth: "<Customer place of birth>", Gender: "0", Document: customerDocument)
        
        return JESDKConfiguration(SubscriptionKey: "<JubaExpress SubscriptionKey>", PartnerKey: "<JubaExpress PartnerKey>", referenceid: referenceId, enviroment: .UAT, customerInfo: customerInfo)
    }
}
