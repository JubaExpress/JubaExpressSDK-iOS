//
//  ViewController.swift
//  JubaExpressSDKSample
//
//  Created by JubaExpressSDK on 23/03/2024.
//

import UIKit
import JubaExpressSDK

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
    }

    @IBAction func didTabStart(_ sender: UIButton) {
        startSDK()
    }
}

extension ViewController: JESDKDelegate {
    
    func setTheme() {
        JESDK.setPrimaryColor(DefaultTheme.Colors.premierBlueColor)
        JESDK.setSecondaryColor(DefaultTheme.Colors.premierGreenColor)
        JESDK.setTertionaryColor(DefaultTheme.Colors.premierBlueColor)
        JESDK.setBackgroundColor(DefaultTheme.Colors.filedBackgroundColor)
        JESDK.setTopHeadingColor(DefaultTheme.Colors.JESDKTopHeadingColor)
        JESDK.setButtonTextColor(.white)
        JESDK.setButtonBackgroundColor(DefaultTheme.Colors.premierGreenColor)
    }
    
    func startSDK(referenceId: String? = nil) {
        
        
        
        JESDK.initSDK(configuration: PaymentSDK().getConfiguration(referenceId: referenceId), root: self)
        JESDK.sharedInstance()?.delegate = self
        
    }
    
    func JESDKSecretKey(payment: Payment) {
//        let vc = PaymentGatewaysListViewController.instantiate(fromJubaExpressStoryboards: .Payment)
//        vc.payment = payment
//        self.navigationController?.pushViewController(vc, animated: true)
    }
}
