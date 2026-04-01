//
//  ContentView.swift
//  JubaExpressSwiftUI
//
//  Created by Muhammad kumail on 23/03/2026.
//

import SwiftUI
import JubaExpressSDK

struct ContentView: View,JESDKDelegate {
    
    var body: some View {
        VStack {
            
            Button("Open SDK") {
                openJubaSDK()
            }.padding()
            
            Button("Open SDK With ReferenceID") {
                openJubaSDK(referenceId: "8230414600")
            }
        }
    }
    
    func openJubaSDK(referenceId: String? = nil) {

        let config = PaymentSDK().getConfiguration(referenceId: referenceId)

        JESDK.initSDK(configuration: config)
        JESDK.sharedInstance()?.delegate = self
    }

    func JESDKSecretKey(payment: Payment) {
        debugPrint("JubaSDK - Payment Details: \(payment)")
    }
}

#Preview {
    ContentView()
}
