//
//  ViewController.swift
//  JubaExpressSDKSample
//
//  Created by JubaExpressSDK on 23/03/2024.
//

import UIKit
import JubaExpressSDK
import Combine

enum ColorTypes {
    case primary
    case secondary
    case tertiary
    case topHeading
    case buttontext
    case buttonBackground
    case fieldBackground
}

class ViewController: UIViewController {
    
    var selectedColorType: ColorTypes?
    var cancellable: [AnyCancellable] = []
    
    @IBOutlet weak var primaryView: UIView!
    @IBOutlet weak var secondryView: UIView!
    @IBOutlet weak var tertiaryView: UIView!
    @IBOutlet weak var fieldView: UIView!
    @IBOutlet weak var buttonbackroundView: UIView!
    @IBOutlet weak var buttonTextView: UIView!
    @IBOutlet weak var topHeadingView: UIView!
    @IBOutlet weak var sendMoneyBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setCustomeColors()
        setTheme()
    }
    
    @IBAction func didTabStart(_ sender: UIButton) {
        startSDK()
    }
    
    func setupNavigation() {
        UINavigationBar.appearance().tintColor = UIColor.white
        self.title = "Juba Express SDK Demo Application"
    }
}

extension ViewController: JESDKDelegate {
    
    func setTheme() {
        JESDK.setPrimaryColor(DefaultTheme.Colors.primary)
        JESDK.setSecondaryColor(DefaultTheme.Colors.secondory)
        JESDK.setTertionaryColor(DefaultTheme.Colors.primary)
        JESDK.setBackgroundColor(DefaultTheme.Colors.filedBackgroundColor)
        JESDK.setTopHeadingColor(DefaultTheme.Colors.TopHeadingColor)
        JESDK.setButtonTextColor(.white)
        JESDK.setButtonBackgroundColor(DefaultTheme.Colors.secondory)
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
extension ViewController: UIColorPickerViewControllerDelegate {
    
    func setCustomeColors() {
        
        primaryView.backgroundColor = DefaultTheme.Colors.primary
        secondryView.backgroundColor = DefaultTheme.Colors.secondory
        tertiaryView.backgroundColor = DefaultTheme.Colors.primary
        fieldView.backgroundColor = DefaultTheme.Colors.filedBackgroundColor
        topHeadingView.backgroundColor = DefaultTheme.Colors.TopHeadingColor
        buttonbackroundView.backgroundColor = DefaultTheme.Colors.secondory
        buttonTextView.backgroundColor = .white
        
        primaryView.makeRoundCornors()
        secondryView.makeRoundCornors()
        tertiaryView.makeRoundCornors()
        fieldView.makeRoundCornors()
        topHeadingView.makeRoundCornors()
        buttonbackroundView.makeRoundCornors()
        buttonTextView.makeRoundCornors()
        sendMoneyBtn.makeRoundCornors()
    }
    
    @IBAction func didTapPrimary(_ sender: UIButton) {
        selectedColorType = .primary
        changeColor()
    }
    
    @IBAction func didTapSecondary(_ sender: UIButton) {
        selectedColorType = .secondary
        changeColor()
    }
    
    @IBAction func didTapTertiary(_ sender: UIButton) {
        selectedColorType = .tertiary
        changeColor()
    }
    
    @IBAction func didTapFiledBackground(_ sender: UIButton) {
        selectedColorType = .fieldBackground
        changeColor()
    }
    
    @IBAction func didTapButtonBackground(_ sender: UIButton) {
        selectedColorType = .buttonBackground
        changeColor()
    }
    
    @IBAction func didTapButtonText(_ sender: UIButton) {
        selectedColorType = .buttontext
        changeColor()
    }
    
    @IBAction func didTapTopHeading(_ sender: UIButton) {
        selectedColorType = .topHeading
        changeColor()
    }
    
    func changeColor() {
        
        if #available(iOS 14.0, *) {
            // Initializing Color Picker
            let picker = UIColorPickerViewController()

            // Setting the Initial Color of the Picker
            picker.selectedColor = self.view.backgroundColor!

            // Setting Delegate
            picker.delegate = self

            // Presenting the Color Picker
            self.present(picker, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
        }
    }
    
    @available(iOS 14.0, *)
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        updateColors(color: viewController.selectedColor)
        self.dismiss(animated: true)
        
    }
    
    //  Called on every color selection done in the picker.
    @available(iOS 14.0, *)
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        updateColors(color: viewController.selectedColor)
        self.dismiss(animated: true)
    }
    
    func updateColors(color: UIColor) {
        
        switch selectedColorType {
            
        case .primary:
            
            primaryView.backgroundColor = color
            JESDK.setPrimaryColor(color)
            
        case .secondary:
            
            secondryView.backgroundColor = color
            JESDK.setSecondaryColor(color)
            
        case .tertiary:
            
            tertiaryView.backgroundColor = color
            JESDK.setTertionaryColor(color)
            
        case .topHeading:
            
            topHeadingView.backgroundColor = color
            JESDK.setTopHeadingColor(color)
            
        case .fieldBackground:
            fieldView.backgroundColor = color
            JESDK.setBackgroundColor(color)
            
        case .buttonBackground:
            
            buttonbackroundView.backgroundColor = color
            JESDK.setButtonBackgroundColor(color)
            
        case .buttontext:
            
            buttonTextView.backgroundColor = color
            JESDK.setButtonTextColor(color)
            
        default:
            break
        }
        
    }
}

public extension UIView {
    
    func makeRoundCornors(radius: Double = 5.0, borderWidth: Double = 1.0, borderColor: UIColor = .lightGray){
        
        self.layer.cornerRadius = radius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.clipsToBounds = true
    }
}
