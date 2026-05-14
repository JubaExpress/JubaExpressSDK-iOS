//
//  SDKThemeViewController.swift
//  Juba Express Money Transfer
//
//  Step 2 of 2 — collects all 9 SDK theme colours then launches the SDK.
//  No storyboard. Fully programmatic.
//

import UIKit
import JubaExpressSDK

final class SDKThemeViewController: UIViewController {

    // ─── Injected from ConfigurationViewController ────────────────────────────
    private let subscriptionKey: String
    private let baseURL:          String
    private let referenceId:      String?
    private let partnerKey:      String
    private let environment:     JESDKBuildEnvironment

    // ─── Theme state (mutated as user picks colours) ──────────────────────────
    private var theme = SDKTheme()

    // ─── Color row descriptors ────────────────────────────────────────────────
    private struct ColorRow {
        let title:   String
        let keyPath: WritableKeyPath<SDKTheme, UIColor>
        var current: UIColor
    }

    private lazy var rows: [ColorRow] = [
        ColorRow(title: "Primary",                      keyPath: \.primary,                  current: theme.primary),
        ColorRow(title: "Secondary",                    keyPath: \.secondary,                current: theme.secondary),
        ColorRow(title: "Tertiary",                     keyPath: \.tertiary,                 current: theme.tertiary),
        ColorRow(title: "Field Background",             keyPath: \.fieldBackground,          current: theme.fieldBackground),
        ColorRow(title: "Top Heading",                  keyPath: \.topHeading,               current: theme.topHeading),
        ColorRow(title: "Button Background",            keyPath: \.buttonBackground,         current: theme.buttonBackground),
        ColorRow(title: "Button Text",                  keyPath: \.buttonText,               current: theme.buttonText),
        ColorRow(title: "Transfer Button Background",   keyPath: \.transferButtonBackground, current: theme.transferButtonBackground),
        ColorRow(title: "Transfer Button Text",         keyPath: \.transferButtonText,       current: theme.transferButtonText),
    ]

    private var selectedRowIndex: Int?

    // ─── UI ───────────────────────────────────────────────────────────────────
    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.register(ColorPickerCell.self, forCellReuseIdentifier: ColorPickerCell.reuseID)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    private let launchButton: UIButton = {
        var cfg                 = UIButton.Configuration.filled()
        cfg.title               = "Launch Payment SDK"
        cfg.image               = UIImage(systemName: "arrow.right.circle.fill")
        cfg.imagePadding        = 8
        cfg.baseBackgroundColor = .systemGreen
        cfg.baseForegroundColor = .white
        cfg.cornerStyle         = .large
        cfg.buttonSize          = .large
        let btn = UIButton(configuration: cfg)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let footerView = UIView()

    // ─── Init ─────────────────────────────────────────────────────────────────
    init(subscriptionKey: String, partnerKey: String, environment: JESDKBuildEnvironment, baseURL: String, referenceId: String? = nil) {
        self.subscriptionKey = subscriptionKey
        self.partnerKey      = partnerKey
        self.environment     = environment
        self.baseURL         = baseURL
        self.referenceId     = referenceId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("Use init(subscriptionKey:partnerKey:environment:baseURL:referenceId:)") }

    // ─── Lifecycle ────────────────────────────────────────────────────────────
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Customize Theme"
        view.backgroundColor = UIColor.systemGroupedBackground
        buildLayout()
        tableView.dataSource = self
        tableView.delegate   = self
        launchButton.addTarget(self, action: #selector(launchTapped), for: .touchUpInside)
    }

    // ─── Layout ───────────────────────────────────────────────────────────────
    private func buildLayout() {
        // Footer holds the launch button
        footerView.frame = CGRect(x: 0, y: 0, width: 0, height: 80)
        footerView.addSubview(launchButton)
        launchButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            launchButton.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 20),
            launchButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -20),
            launchButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            launchButton.heightAnchor.constraint(equalToConstant: 52)
        ])
        tableView.tableFooterView = footerView

        view.addSubview(tableView)
        let g = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: g.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: g.bottomAnchor)
        ])
    }

    // ─── Launch SDK ───────────────────────────────────────────────────────────
    @objc private func launchTapped() {
        let sdk = PaymentSDK()

        let configuration = sdk.getConfiguration(
            subscriptionKey: subscriptionKey,
            partnerKey:      partnerKey,
            environment:     environment,
            baseURL:         baseURL,
            referenceId:     referenceId
        )

        sdk.applyThemeAndStart(
            configuration: configuration,
            theme:         theme,
            delegate:      self
        )
    }

    // ─── Color picker ─────────────────────────────────────────────────────────
    private func presentColorPicker(for index: Int) {
        selectedRowIndex = index
        if #available(iOS 14.0, *) {
            let picker = UIColorPickerViewController()
            picker.selectedColor = rows[index].current
            picker.delegate      = self
            present(picker, animated: true)
        } else {
            showAlert("Color picker requires iOS 14+")
        }
    }

    private func applyColor(_ color: UIColor, to index: Int) {
        rows[index].current = color
        theme[keyPath: rows[index].keyPath] = color
        let ip = IndexPath(row: index, section: 0)
        tableView.reloadRows(at: [ip], with: .none)
    }

    private func showAlert(_ msg: String) {
        let a = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        a.addAction(UIAlertAction(title: "OK", style: .default))
        present(a, animated: true)
    }
}

// MARK: - JESDKDelegate
extension SDKThemeViewController: JESDKDelegate {

    func JESDKSecretKey(payment: Payment) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let message = """
            Reference ID:   \(payment.referenceId   ?? "N/A")
            Secret Key:     \(payment.secretkey      ?? "N/A")

            Sender Amount:  \(payment.SentAmount     ?? 0.0) \(payment.currencyCode ?? "")
            Total Sent:     \(payment.totalSentAmount ?? 0.0)
            Commission:     \(payment.CommissionAmount ?? 0.0)

            Beneficiary:    \(payment.BeneficiaryName   ?? "N/A")
            Mobile:         \(payment.BeneficiaryMobile ?? "N/A")
            Account:        \(payment.AccountNo          ?? "N/A")

            Destination:    \(payment.DestinationCountry     ?? "N/A")
            Country Code:   \(payment.DestinationCountryCode ?? "N/A")

            Payment Mode:   \(payment.PaymentMode    ?? "N/A")
            Pay Currency:   \(payment.PayCurrencyCode ?? "N/A")
            Payout Amount:  \(payment.PayoutAmount    ?? 0.0)

            Source of Funds:\(payment.SourceOfFunds          ?? "N/A")
            Purpose:        \(payment.Purpose                 ?? "N/A")
            Relationship:   \(payment.BeneficiaryRelationship ?? "N/A")
            """

            let alert = UIAlertController(title: "Remittance Details",
                                          message: message,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
}

// MARK: - UITableViewDataSource & Delegate
extension SDKThemeViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ColorPickerCell.reuseID,
                                                 for: indexPath) as! ColorPickerCell
        cell.configure(title: rows[indexPath.row].title, color: rows[indexPath.row].current)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presentColorPicker(for: indexPath.row)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 56 }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Tap a row to change its colour"
    }
}

// MARK: - UIColorPickerViewControllerDelegate
@available(iOS 14.0, *)
extension SDKThemeViewController: UIColorPickerViewControllerDelegate {

    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        guard let idx = selectedRowIndex else { return }
        applyColor(viewController.selectedColor, to: idx)
    }

    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        guard let idx = selectedRowIndex else { return }
        applyColor(viewController.selectedColor, to: idx)
    }
}

// MARK: - ColorPickerCell (self-contained table cell)

final class ColorPickerCell: UITableViewCell {

    static let reuseID = "ColorPickerCell"

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 15, weight: .regular)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let swatchView: UIView = {
        let v = UIView()
        v.layer.cornerRadius  = 12
        v.layer.borderWidth   = 1
        v.layer.borderColor   = UIColor.separator.cgColor
        v.clipsToBounds       = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let chevron: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "chevron.right"))
        iv.tintColor = .tertiaryLabel
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(titleLabel)
        contentView.addSubview(swatchView)
        contentView.addSubview(chevron)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            chevron.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            chevron.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chevron.widthAnchor.constraint(equalToConstant: 14),

            swatchView.trailingAnchor.constraint(equalTo: chevron.leadingAnchor, constant: -12),
            swatchView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            swatchView.widthAnchor.constraint(equalToConstant: 28),
            swatchView.heightAnchor.constraint(equalToConstant: 28)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(title: String, color: UIColor) {
        titleLabel.text           = title
        swatchView.backgroundColor = color
    }
}
