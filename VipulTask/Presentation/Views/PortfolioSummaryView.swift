//
//  PortfolioSummaryView.swift
//  VipulTask
//
//  Created by Vipul Kumar on 15/01/26.
//

import UIKit

final class PortfolioSummaryView: UIView {

    // MARK: - UI

    private let stackView = UIStackView()
    private let expandButton = UIButton(type: .system)

    // MARK: - State

    private var expandableRows: [UIView] = []
    private var isExpanded = false

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupUI() {
        // Same background as holdings list
        backgroundColor = .secondarySystemBackground

        // Rounded TOP border only (matches screenshot)
        layer.cornerRadius = 12
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.masksToBounds = true

        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .fill
        stackView.distribution = .fill

        addSubview(stackView)
    }

    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false

        // NO padding left / right / bottom
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // MARK: - Configure

    func configure(summary: PortfolioSummary) {

        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        expandableRows.removeAll()
        isExpanded = false
        expandButton.transform = .identity

        // Expandable rows (hidden initially)
        let currentValue = makeRow("Current value*", summary.currentValue)
        let totalInvestment = makeRow("Total investment*", summary.totalInvestment)
        let todaysPNL = makeRow("Today's Profit & Loss*", summary.todaysPNL, summary.todaysPNL >= 0 ? .systemGreen : .systemRed)

        expandableRows = [currentValue, totalInvestment, todaysPNL]

        expandableRows.forEach {
            $0.isHidden = true
            stackView.addArrangedSubview($0)
        }

        // Always visible Profit & Loss row
        stackView.addArrangedSubview(makeProfitLossRow(summary.totalPNL, summary.totalPNLPercentage))
    }
    
    private func makeRow(_ title: String, _ value: Double, _ textColor: UIColor = .secondaryLabel) -> UIView {
        let row = UIView()
        row.backgroundColor = .secondarySystemBackground
        row.heightAnchor.constraint(equalToConstant: 44).isActive = true

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.textColor = .secondaryLabel

        let valueLabel = UILabel()
        valueLabel.text = String(format: "₹ %.2f", value)
        valueLabel.font = .systemFont(ofSize: 14)
        valueLabel.textAlignment = .right
        valueLabel.textColor = textColor

        row.addSubview(titleLabel)
        row.addSubview(valueLabel)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: row.centerYAnchor),

            valueLabel.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: -16),
            valueLabel.centerYAnchor.constraint(equalTo: row.centerYAnchor),

            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: valueLabel.leadingAnchor, constant: -8)
        ])

        return row
    }

    
    private func makeProfitLossRow(_ value: Double, _ percantage: Double) -> UIView {
        let row = UIView()
        row.backgroundColor = .secondarySystemBackground
        row.heightAnchor.constraint(equalToConstant: 56).isActive = true

        let contentStack = UIStackView()
        contentStack.axis = .horizontal
        contentStack.alignment = .center
        contentStack.spacing = 6

        let titleLabel = UILabel()
        titleLabel.text = "Profit & Loss*"
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.textColor = .secondaryLabel

        expandButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        expandButton.tintColor = .label
        expandButton.addTarget(self, action: #selector(toggleExpand), for: .touchUpInside)

        let valueLabel = UILabel()
        valueLabel.text = String(
            format: "₹ %.2f (%.2f%%)",
            value,
            percantage
        )
        valueLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        valueLabel.textColor = value >= 0 ? .systemGreen : .systemRed
        valueLabel.textAlignment = .right

        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(expandButton)

        row.addSubview(contentStack)
        row.addSubview(valueLabel)

        contentStack.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Content padding (THIS fixes the issue)
            contentStack.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 16),
            contentStack.centerYAnchor.constraint(equalTo: row.centerYAnchor),

            valueLabel.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: -16),
            valueLabel.centerYAnchor.constraint(equalTo: row.centerYAnchor),

            contentStack.trailingAnchor.constraint(lessThanOrEqualTo: valueLabel.leadingAnchor, constant: -8)
        ])

        return row
    }



    // MARK: - Actions

    @objc private func toggleExpand() {
        isExpanded.toggle()

        expandableRows.forEach { $0.isHidden = !isExpanded }

        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut]) {
            self.expandButton.transform =
                self.isExpanded ? CGAffineTransform(rotationAngle: .pi) : .identity
            self.layoutIfNeeded()
        }
    }
}
