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
        leftStack.spacing = 10
        leftStack.alignment = .leading
        
        rightStack.axis = .vertical
        rightStack.spacing = 10
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
        
        quantityLabel.attributedText = makeAttributedText(
            label: "NET QTY: ",
            value: "\(holding.quantity)",
            labelFont: .systemFont(ofSize: 13),
            valueFont: .systemFont(ofSize: 14)
        )
        
        ltpLabel.attributedText = makeAttributedText(
            label: "LTP: ",
            value: "₹ \(String(format: "%.2f", holding.ltp))",
            labelFont: .systemFont(ofSize: 14),
            valueFont: .systemFont(ofSize: 14)
        )
        
        let pnl = (holding.ltp - holding.avgPrice) * Double(holding.quantity)
        let isProfit = pnl >= 0
        let pnlColor: UIColor = isProfit ? .systemGreen : .systemRed
        
        let formattedValue = String(format: "%.2f", abs(pnl))
        let pnlTextValue = isProfit
        ? "₹ \(formattedValue)"
        : "-₹ \(formattedValue)"
        
        pnlLabel.attributedText = makeAttributedText(
            label: "P&L: ",
            value: pnlTextValue,
            labelFont: .systemFont(ofSize: 14),
            valueFont: .boldSystemFont(ofSize: 14),
            valueColor: pnlColor
        )
    }
    
    
    private func makeAttributedText(
        label: String,
        value: String,
        labelFont: UIFont,
        valueFont: UIFont,
        labelColor: UIColor = .secondaryLabel,
        valueColor: UIColor = .label
    ) -> NSAttributedString {
        
        let text = NSMutableAttributedString(
            string: label,
            attributes: [
                .font: labelFont,
                .foregroundColor: labelColor
            ]
        )
        
        text.append(NSAttributedString(
            string: value,
            attributes: [
                .font: valueFont,
                .foregroundColor: valueColor
            ]
        ))
        
        return text
    }
    
}
