//
//  ConfigurationViewController.swift
//  Juba Express Money Transfer
//
//  Step 1 of 2 — collects SubscriptionKey, PartnerKey, ReferenceID (optional)
//  Environment is always UAT
//

import UIKit
import JubaExpressSDK

final class ConfigurationViewController: UIViewController {

    // ─── Demo credentials ─────────────────────────────────────────────────────
    private let demoSubscriptionKey = "YOUR_DEMO_SUBSCRIPTION_KEY"
    private let demoPartnerKey      = "YOUR_DEMO_PARTNER_KEY"
    private let uatBaseURL          = "YOUR_DEMO_BASE_URL"

    // ─── UI ───────────────────────────────────────────────────────────────────

    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode        = .scaleAspectFit
        iv.clipsToBounds      = true
        iv.image              = UIImage(named: "AppLogo")
        iv.backgroundColor    = UIColor.systemGray6
        iv.layer.cornerRadius = 16
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let cardView: UIView = {
        let v = UIView()
        v.backgroundColor     = .systemBackground
        v.layer.cornerRadius  = 20
        v.layer.shadowColor   = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.08
        v.layer.shadowRadius  = 16
        v.layer.shadowOffset  = CGSize(width: 0, height: 4)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let subscriptionKeyTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder            = "Subscription Key"
        tf.borderStyle            = .none
        tf.autocorrectionType     = .no
        tf.autocapitalizationType = .none
        tf.returnKeyType          = .next
        tf.clearButtonMode        = .whileEditing
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private let partnerKeyTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder            = "Partner Key"
        tf.borderStyle            = .none
        tf.autocorrectionType     = .no
        tf.autocapitalizationType = .none
        tf.returnKeyType          = .next
        tf.clearButtonMode        = .whileEditing
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private let referenceIdTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder            = "Transaction Reference ID (Optional)"
        tf.borderStyle            = .none
        tf.autocorrectionType     = .no
        tf.autocapitalizationType = .none
        tf.returnKeyType          = .done
        tf.clearButtonMode        = .whileEditing
        tf.textColor              = .label
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private let separator1 = ConfigurationViewController.makeSeparator()
    private let separator2 = ConfigurationViewController.makeSeparator()

    private let nextButton: UIButton = {
        var cfg                 = UIButton.Configuration.filled()
        cfg.title               = "Next: Customize Theme →"
        cfg.baseBackgroundColor = .systemBlue
        cfg.baseForegroundColor = .white
        cfg.cornerStyle         = .large
        cfg.buttonSize          = .large
        let btn = UIButton(configuration: cfg)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let orDividerView: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        let leftLine  = UIView()
        leftLine.backgroundColor = UIColor.separator
        leftLine.translatesAutoresizingMaskIntoConstraints = false

        let rightLine = UIView()
        rightLine.backgroundColor = UIColor.separator
        rightLine.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text          = "OR"
        label.font          = .systemFont(ofSize: 12, weight: .medium)
        label.textColor     = .tertiaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(leftLine)
        container.addSubview(label)
        container.addSubview(rightLine)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            label.widthAnchor.constraint(equalToConstant: 36),

            leftLine.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            leftLine.trailingAnchor.constraint(equalTo: label.leadingAnchor, constant: -8),
            leftLine.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            leftLine.heightAnchor.constraint(equalToConstant: 0.5),

            rightLine.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 8),
            rightLine.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            rightLine.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            rightLine.heightAnchor.constraint(equalToConstant: 0.5)
        ])
        return container
    }()

    private let exploreDemoButton: UIButton = {
        var cfg                 = UIButton.Configuration.bordered()
        cfg.title               = "Explore Demo Application"
        cfg.image               = UIImage(systemName: "sparkles")
        cfg.imagePadding        = 8
        cfg.baseBackgroundColor = .systemBackground
        cfg.baseForegroundColor = .systemBlue
        cfg.cornerStyle         = .large
        cfg.buttonSize          = .large
        let btn = UIButton(configuration: cfg)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    // Row containers
    private let subKeyRow     = UIView.fieldRow()
    private let partnerKeyRow = UIView.fieldRow()
    private let referenceRow  = UIView.fieldRow()

    private lazy var cardStack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            subKeyRow,
            separator1,
            partnerKeyRow,
            separator2,
            referenceRow
        ])
        sv.axis    = .vertical
        sv.spacing = 0
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    // ─── Lifecycle ────────────────────────────────────────────────────────────

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "SDK Configuration"
        view.backgroundColor = UIColor.systemGroupedBackground
        buildLayout()
        wireActions()
    }

    // ─── Layout ───────────────────────────────────────────────────────────────

    private func buildLayout() {
        embed(subscriptionKeyTextField, in: subKeyRow,     iconName: "key.fill")
        embed(partnerKeyTextField,      in: partnerKeyRow, iconName: "person.badge.key.fill")
        embed(referenceIdTextField,     in: referenceRow,  iconName: "number.circle.fill",
              isOptional: true)

        [logoImageView, cardView,
         nextButton, orDividerView, exploreDemoButton].forEach { view.addSubview($0) }
        cardView.addSubview(cardStack)

        let g = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            // Logo
            logoImageView.topAnchor.constraint(equalTo: g.topAnchor, constant: 28),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 110),
            logoImageView.heightAnchor.constraint(equalToConstant: 110),

            // Card — directly below logo
            cardView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 32),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            cardStack.topAnchor.constraint(equalTo: cardView.topAnchor),
            cardStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            cardStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            cardStack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),

            subKeyRow.heightAnchor.constraint(equalToConstant: 56),
            partnerKeyRow.heightAnchor.constraint(equalToConstant: 56),
            referenceRow.heightAnchor.constraint(equalToConstant: 56),
            separator1.heightAnchor.constraint(equalToConstant: 0.5),
            separator2.heightAnchor.constraint(equalToConstant: 0.5),

            // Next
            nextButton.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 32),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.heightAnchor.constraint(equalToConstant: 52),

            // OR
            orDividerView.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 20),
            orDividerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            orDividerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            orDividerView.heightAnchor.constraint(equalToConstant: 20),

            // Explore Demo
            exploreDemoButton.topAnchor.constraint(equalTo: orDividerView.bottomAnchor, constant: 20),
            exploreDemoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            exploreDemoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            exploreDemoButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }

    private func wireActions() {
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        exploreDemoButton.addTarget(self, action: #selector(exploreDemoTapped), for: .touchUpInside)
        subscriptionKeyTextField.delegate = self
        partnerKeyTextField.delegate      = self
        referenceIdTextField.delegate     = self
        view.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        )
    }

    // ─── Actions ──────────────────────────────────────────────────────────────

    @objc private func nextTapped() {
        guard
            let sub = subscriptionKeyTextField.text, !sub.trimmed.isEmpty,
            let prt = partnerKeyTextField.text,      !prt.trimmed.isEmpty
        else {
            showAlert("Please fill in both Subscription Key and Partner Key.")
            return
        }

        let referenceId: String? = referenceIdTextField.text?.trimmed.isEmpty == false
            ? referenceIdTextField.text?.trimmed : nil

        pushThemeVC(subscriptionKey: sub.trimmed,
                    partnerKey:      prt.trimmed,
                    referenceId:     referenceId)
    }

    @objc private func exploreDemoTapped() {
        pushThemeVC(subscriptionKey: demoSubscriptionKey,
                    partnerKey:      demoPartnerKey,
                    referenceId:     nil)
    }

    private func pushThemeVC(subscriptionKey: String,
                             partnerKey: String,
                             referenceId: String?) {
        let themeVC = SDKThemeViewController(
            subscriptionKey: subscriptionKey,
            partnerKey:      partnerKey,
            environment:     .UAT,          // always UAT
            baseURL:         uatBaseURL,    // always UAT base URL
            referenceId:     referenceId
        )
        navigationController?.pushViewController(themeVC, animated: true)
    }

    @objc private func dismissKeyboard() { view.endEditing(true) }

    // ─── Helpers ──────────────────────────────────────────────────────────────

    private func embed(_ tf: UITextField, in row: UIView,
                       iconName: String, isOptional: Bool = false) {
        let icon = UIImageView(image: UIImage(systemName: iconName))
        icon.tintColor   = isOptional ? .tertiaryLabel : .secondaryLabel
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        row.addSubview(icon)
        row.addSubview(tf)

        if isOptional {
            let badge = UILabel()
            badge.text      = "Optional"
            badge.font      = .systemFont(ofSize: 11, weight: .regular)
            badge.textColor = .tertiaryLabel
            badge.translatesAutoresizingMaskIntoConstraints = false
            row.addSubview(badge)
            NSLayoutConstraint.activate([
                badge.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: -16),
                badge.centerYAnchor.constraint(equalTo: row.centerYAnchor),
                tf.trailingAnchor.constraint(equalTo: badge.leadingAnchor, constant: -8)
            ])
        } else {
            tf.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: -16).isActive = true
        }

        NSLayoutConstraint.activate([
            icon.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 16),
            icon.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 20),
            icon.heightAnchor.constraint(equalToConstant: 20),
            tf.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 12),
            tf.centerYAnchor.constraint(equalTo: row.centerYAnchor)
        ])
    }

    private func showAlert(_ msg: String) {
        let a = UIAlertController(title: "Missing Fields", message: msg, preferredStyle: .alert)
        a.addAction(UIAlertAction(title: "OK", style: .default))
        present(a, animated: true)
    }

    private static func makeSeparator() -> UIView {
        let v = UIView()
        v.backgroundColor = UIColor.separator
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }
}

// MARK: - UITextFieldDelegate
extension ConfigurationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case subscriptionKeyTextField: partnerKeyTextField.becomeFirstResponder()
        case partnerKeyTextField:      referenceIdTextField.becomeFirstResponder()
        default:                       textField.resignFirstResponder()
        }
        return true
    }
}

// MARK: - UIView / String helpers
extension UIView {
    static func fieldRow() -> UIView {
        let v = UIView()
        v.backgroundColor = .clear
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }
}

private extension String {
    var trimmed: String { trimmingCharacters(in: .whitespaces) }
}
