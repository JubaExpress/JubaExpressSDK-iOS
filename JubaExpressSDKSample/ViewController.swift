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
    case transferBackground
    case transferText
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
    @IBOutlet weak var transfetTextColor: UIView!
    @IBOutlet weak var transferBtnBackgroundView: UIView!
    
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

// MARK: - SDK Delegate
extension ViewController: JESDKDelegate {
    
    func setTheme() {
        JESDK.setPrimaryColor(DefaultTheme.Colors.primary)
        JESDK.setSecondaryColor(DefaultTheme.Colors.secondory)
        JESDK.setTertionaryColor(DefaultTheme.Colors.primary)
        JESDK.setBackgroundColor(DefaultTheme.Colors.filedBackgroundColor)
        JESDK.setTopHeadingColor(DefaultTheme.Colors.TopHeadingColor)
        JESDK.setButtonTextColor(.white)
        JESDK.setButtonBackgroundColor(DefaultTheme.Colors.secondory)
        JESDK.setCreateRemittanceText("Create Remittance")
        JESDK.setStartTransferButtonTextColor(.white)
        JESDK.setStartTransferButtonBackgroundColor(.black)
    }
    
    func startSDK(referenceId: String? = nil) {
        
        JESDK.initSDK(configuration: PaymentSDK().getConfiguration(referenceId: referenceId))
        JESDK.sharedInstance()?.delegate = self
    }
    
    func JESDKSecretKey(payment: Payment) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            let message = """
            Reference ID: \(payment.referenceId ?? "N/A")
            Secret Key: \(payment.secretkey ?? "N/A")
            
            Sender Amount: \(payment.SentAmount ?? 0.0) \(payment.currencyCode ?? "")
            Total Sent: \(payment.totalSentAmount ?? 0.0)
            Commission: \(payment.CommissionAmount ?? 0.0)
            
            Beneficiary: \(payment.BeneficiaryName ?? "N/A")
            Mobile: \(payment.BeneficiaryMobile ?? "N/A")
            Account: \(payment.AccountNo ?? "N/A")
            
            Destination Country: \(payment.DestinationCountry ?? "N/A")
            Country Code: \(payment.DestinationCountryCode ?? "N/A")
            
            Payment Mode: \(payment.PaymentMode ?? "N/A")
            Pay Currency: \(payment.PayCurrencyCode ?? "N/A")
            Payout Amount: \(payment.PayoutAmount ?? 0.0)
            
            Source of Funds: \(payment.SourceOfFunds ?? "N/A")
            Purpose: \(payment.Purpose ?? "N/A")
            Relationship: \(payment.BeneficiaryRelationship ?? "N/A")
            """
            
            let alert = UIAlertController(title: "Remittance Details",message: message,preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            self.present(alert, animated: true)
        }
    }
}

// MARK: - Color Handling
extension ViewController {
    
    func setCustomeColors() {
        
        primaryView.backgroundColor = DefaultTheme.Colors.primary
        secondryView.backgroundColor = DefaultTheme.Colors.secondory
        tertiaryView.backgroundColor = DefaultTheme.Colors.primary
        fieldView.backgroundColor = DefaultTheme.Colors.filedBackgroundColor
        topHeadingView.backgroundColor = DefaultTheme.Colors.TopHeadingColor
        buttonbackroundView.backgroundColor = DefaultTheme.Colors.secondory
        buttonTextView.backgroundColor = .white
        
        [primaryView, secondryView, tertiaryView, fieldView,
         topHeadingView, buttonbackroundView, buttonTextView,transfetTextColor,transferBtnBackgroundView].forEach {
            $0?.makeRoundCornors()
        }
        
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
    
    @IBAction func didTabSelectTransferBtnTextColor(_ sender: UIButton) {
        selectedColorType = .transferText
        changeColor()
    }
    
    @IBAction func didTabSelectTransferbtbBacgroundColor(_ sender: UIButton) {
        selectedColorType = .transferBackground
        changeColor()
    }
    
    func changeColor() {
        if #available(iOS 14.0, *) {
            let picker = UIColorPickerViewController()
            picker.selectedColor = self.view.backgroundColor ?? .white
            picker.delegate = self
            self.present(picker, animated: true)
        } else {
            // Optional: show alert or fallback UI
            print("Color picker requires iOS 14+")
        }
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
            
        case .transferBackground:
            transferBtnBackgroundView.backgroundColor = color
            JESDK.setStartTransferButtonBackgroundColor(color)
            
        case .transferText:
            transfetTextColor.backgroundColor = color
            JESDK.setStartTransferButtonTextColor(color)
            
        default:
            break
        }
    }
}

// MARK: - Color Picker Delegate (FIXED)
@available(iOS 14.0, *)
extension ViewController: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        updateColors(color: viewController.selectedColor)
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        updateColors(color: viewController.selectedColor)
        self.dismiss(animated: true)
    }
}

// MARK: - UIView Extension
public extension UIView {
    
    func makeRoundCornors(radius: Double = 5.0,borderWidth: Double = 1.0, borderColor: UIColor = .lightGray) {
        
        self.layer.cornerRadius = radius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.clipsToBounds = true
    }
}

