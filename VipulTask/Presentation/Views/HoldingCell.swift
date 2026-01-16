//
//  HoldingCell.swift
//  VipulTask
//
//  Created by Vipul Kumar on 15/01/26.
//

import UIKit

final class HoldingCell: UITableViewCell {

    // MARK: - Reuse

    static let reuseIdentifier = "HoldingCell"

    // MARK: - UI Elements

    private let symbolLabel = UILabel()
    private let quantityLabel = UILabel()
    private let ltpLabel = UILabel()
    private let pnlLabel = UILabel()

    private let leftStack = UIStackView()
    private let rightStack = UIStackView()
    private let containerStack = UIStackView()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI

    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .systemBackground

        symbolLabel.font = .boldSystemFont(ofSize: 16)
        symbolLabel.textColor = .label

        quantityLabel.font = .systemFont(ofSize: 13)
        quantityLabel.textColor = .secondaryLabel

        ltpLabel.font = .systemFont(ofSize: 14)
        ltpLabel.textColor = .label
        ltpLabel.textAlignment = .right

        pnlLabel.font = .boldSystemFont(ofSize: 14)
        pnlLabel.textAlignment = .right

        leftStack.axis = .vertical
        leftStack.spacing = 4
        leftStack.alignment = .leading

        rightStack.axis = .vertical
        rightStack.spacing = 4
        rightStack.alignment = .trailing

        containerStack.axis = .horizontal
        containerStack.alignment = .center
        containerStack.distribution = .fill
        containerStack.spacing = 12

        leftStack.addArrangedSubview(symbolLabel)
        leftStack.addArrangedSubview(quantityLabel)

        rightStack.addArrangedSubview(ltpLabel)
        rightStack.addArrangedSubview(pnlLabel)

        containerStack.addArrangedSubview(leftStack)
        containerStack.addArrangedSubview(rightStack)

        contentView.addSubview(containerStack)
    }

    // MARK: - Layout

    private func setupConstraints() {
        containerStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            containerStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            containerStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    // MARK: - Configuration
    
    func configure(with holding: Holding) {

        symbolLabel.text = holding.symbol
        quantityLabel.text = "NET QTY: \(holding.quantity)"

        let ltpText = NSMutableAttributedString(
            string: "LTP: ",
            attributes: [
                .font: UIFont.systemFont(ofSize: 14),
                .foregroundColor: UIColor.secondaryLabel
            ]
        )

        ltpText.append(NSAttributedString(
            string: "₹ \(String(format: "%.2f", holding.ltp))",
            attributes: [
                .font: UIFont.systemFont(ofSize: 14),
                .foregroundColor: UIColor.label
            ]
        ))

        ltpLabel.attributedText = ltpText

        // P&L calculation
        let pnl = (holding.ltp - holding.avgPrice) * Double(holding.quantity)
        let pnlColor: UIColor = pnl >= 0 ? .systemGreen : .systemRed

        // P&L: label (secondary) + value (green/red)
        let pnlText = NSMutableAttributedString(
            string: "P&L: ",
            attributes: [
                .font: UIFont.systemFont(ofSize: 14),
                .foregroundColor: UIColor.secondaryLabel
            ]
        )

        pnlText.append(NSAttributedString(
            string: "₹ \(String(format: "%.2f", pnl))",
            attributes: [
                .font: UIFont.boldSystemFont(ofSize: 14),
                .foregroundColor: pnlColor
            ]
        ))

        pnlLabel.attributedText = pnlText
    }

}
