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
    
    private func makeRow(
        _ title: String,
        _ value: Double,
        _ textColor: UIColor = .secondaryLabel
    ) -> UIView {
        
        let row = UIView()
        row.backgroundColor = .secondarySystemBackground
        row.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.textColor = .secondaryLabel
        
        let valueLabel = UILabel()
        let formatted = formattedCurrency(value)
        valueLabel.text = formatted.text
        valueLabel.font = .systemFont(ofSize: 14)
        valueLabel.textAlignment = .right
        valueLabel.textColor = formatted.color
        
        row.addSubview(titleLabel)
        row.addSubview(valueLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            
            valueLabel.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: -16),
            valueLabel.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            
            titleLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: valueLabel.leadingAnchor,
                constant: -8
            )
        ])
        
        return row
    }
    
    private func makeProfitLossRow(_ value: Double, _ percentage: Double) -> UIView {
        
        let row = UIView()
        row.backgroundColor = .secondarySystemBackground
        row.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        let separator = UIView()
        separator.backgroundColor = .separator
        
        let contentStack = UIStackView()
        contentStack.axis = .horizontal
        contentStack.alignment = .center
        contentStack.spacing = 6
        
        let titleLabel = UILabel()
        titleLabel.text = "Profit & Loss*"
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.textColor = .secondaryLabel
        
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold)
        expandButton.setImage(UIImage(systemName: "chevron.up", withConfiguration: config), for: .normal)
        expandButton.tintColor = .secondaryLabel
        expandButton.addTarget(self, action: #selector(toggleExpand), for: .touchUpInside)
        
        let valueLabel = UILabel()
        let formatted = formattedCurrency(value)
        valueLabel.text = "\(formatted.text) (\(String(format: "%.2f", percentage))%)"
        valueLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        valueLabel.textColor = formatted.color
        valueLabel.textAlignment = .right
        
        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(expandButton)
        
        row.addSubview(separator)
        row.addSubview(contentStack)
        row.addSubview(valueLabel)
        
        separator.translatesAutoresizingMaskIntoConstraints = false
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separator.topAnchor.constraint(equalTo: row.topAnchor),
            separator.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 16),
            separator.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: -16),
            separator.heightAnchor.constraint(equalToConstant: 0.5),
            
            contentStack.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 16),
            contentStack.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            
            valueLabel.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: -16),
            valueLabel.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            
            contentStack.trailingAnchor.constraint(
                lessThanOrEqualTo: valueLabel.leadingAnchor,
                constant: -8
            )
        ])
        
        return row
    }
    
    private func formattedCurrency(_ value: Double) -> (text: String, color: UIColor) {
        let isProfit = value >= 0
        let amount = String(format: "%.2f", abs(value))
        let text = isProfit ? "₹ \(amount)" : "-₹ \(amount)"
        let color: UIColor = isProfit ? .systemGreen : .systemRed
        return (text, color)
    }
    
    
    
    // MARK: - Actions
    
    @objc private func toggleExpand() {
        isExpanded.toggle()
        
        if isExpanded {
            // Prepare for expand
            expandableRows.forEach {
                $0.isHidden = false
                $0.alpha = 0
                $0.transform = CGAffineTransform(translationX: 0, y: -6)
            }
        }
        
        UIView.animate(
            withDuration: 0.35,
            delay: 0,
            usingSpringWithDamping: 0.9,
            initialSpringVelocity: 0.6,
            options: [.curveEaseInOut],
            animations: {
                
                self.expandableRows.forEach {
                    $0.alpha = self.isExpanded ? 1 : 0
                    $0.transform = self.isExpanded
                    ? .identity
                    : CGAffineTransform(translationX: 0, y: -6)
                }
                
                self.expandButton.transform =
                self.isExpanded
                ? CGAffineTransform(rotationAngle: .pi)
                : .identity
                
                self.superview?.layoutIfNeeded()
            },
            completion: { _ in
                // Hide ONLY after collapse animation completes
                if !self.isExpanded {
                    self.expandableRows.forEach {
                        $0.isHidden = true
                        $0.transform = .identity
                    }
                }
            }
        )
    }
}
