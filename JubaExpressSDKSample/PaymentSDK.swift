//
//  StartSDK.swift
//  Juba Express Money Transfer
//
//  Created by JubaExpressSDK on 20/05/2023.
//

import Foundation
import JubaExpressSDK


//public class PaymentSDK {
//    
//    public init() {}
//    
//    public func getConfiguration(referenceId: String? = nil) -> JESDKConfiguration {
//        
//        
//        let customerDocument = JESSDKCustomerDocument(DocumentType: "0" , DocumentNumber: "<Customer Document Nubmber>", DocumentIssueDate:"<Customer Document Issue Date format DD/MM/YYYY>", DocumentExpiryDate: "<Customer Document Expiry Date format DD/MM/YYYY>", DocumentIssuingCountry: "")
//        
//        let customerName = JESSDKCustomerName(FirstName:  "<Customer first name>", MiddleName: "", LastName: "<Customer Last name>")
//        
//        let customerInfo = JESSDKCustomerInfo(name: customerName, CIF: "<Your CIF>", mobile: "<Customer registered mobile mumber>", email: "<Customer registered email address>", nationality: "<Customer nationality>", DateOfBirth:"<Customer Dob format DD/MM/YYYY>",  PlaceOfBirth: "<Customer place of birth>", Gender: "0", Document: customerDocument)
//        
//        return JESDKConfiguration(SubscriptionKey: "<JubaExpress SubscriptionKey>", PartnerKey: "<JubaExpress PartnerKey>", referenceid: referenceId, enviroment: .UAT, customerInfo: customerInfo)
//    }
//}


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
                                              nationality: "Kenyan",
                                              DateOfBirth:"29/06/1983",
                                              PlaceOfBirth: "Kenya",
                                              Gender: "0",
                                              Document: customerDocument)
        
        return JESDKConfiguration(BaseURL: "https://online.jubaexpress.net/JubaExpressSDKAPIs/",
                                  SubscriptionKey: getKeys().0,
                                  PartnerKey: getKeys().1,
                                  referenceid: referenceId,
                                  customerInfo: customerInfo,
                                  enviroment: .UAT,
                                  IsViewTransactionHistory: false)
    }
    
    func getKeys() -> (String, String, String) {
        //        JUBA SubscriptionKey, PartnerKey
        return ("55DCEA16A6BFA66B737723613B84E", "kjxBciKeXc9dta8jbRWqPql03691zTrM", "133992")
        
//        TUMA SubscriptionKey, PartnerKey
        //return ("29567343239182521348360709619991", "30562587935602040249463742731664", "62836283716273")
        
        //MTN
//        return ("6tyfnnM5Xdi4MNbA1drf2M3P3ecKeFog", "dVFPzhgXdm7MFYGfCb1DQcS4JqfAmtT2", "62836283716273WERW")
    }
}

