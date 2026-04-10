//
//  PaymentSDK.swift
//  Juba SDK Tests
//
//  Created by John Wamunye on 18/03/2026.
//

import Foundation
import JubaExpressSDK

public class PaymentSDK {
    
    public init() {}
    
    public func getConfiguration(referenceId: String? = nil) -> JESDKConfiguration {
        
        
        let customerDocument = JESSDKCustomerDocument(DocumentType: "0" ,
                                                      DocumentNumber: "34505-9519963-9",
                                                      DocumentIssueDate:"19/01/2023",
                                                      DocumentExpiryDate: "19/01/2033",
                                                      DocumentIssuingCountry: "")
        
        let customerName = JESSDKCustomerName(FirstName: "John",
                                              MiddleName: "",
                                              LastName: "Doe")
        
        let customerInfo = JESSDKCustomerInfo(name: customerName,
                                              CIF: getKeys().2,
                                              mobile: "447000000000",
                                              email: "john@middle.doe",
                                              nationality: "XYZ",
                                              DateOfBirth:"29/06/1983",
                                              PlaceOfBirth: "XYZ",
                                              Gender: "0",
                                              Document: customerDocument)
        
        return JESDKConfiguration(BaseURL: "BaseURL",
                                  SubscriptionKey: getKeys().0,
                                  PartnerKey: getKeys().1,
                                  referenceid: referenceId,
                                  customerInfo: customerInfo,
                                  enviroment: .UAT,
                                  IsViewTransactionHistory: false)
    }
    
    func getKeys() -> (String, String, String) {
        //    SubscriptionKey, PartnerKey , CIF
        return ("SubscriptionKey", "PartnerKey", "CIF")
    }
}

