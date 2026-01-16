//
//  HoldingsViewController.swift
//  VipulTask
//
//  Created by Vipul Kumar on 15/01/26.
//

import UIKit

final class HoldingsViewController: UIViewController {

    // MARK: - UI

    private let tableView = UITableView(frame: .zero, style: .plain)
    private let summaryView = PortfolioSummaryView()

    // MARK: - ViewModel

    private let viewModel = HoldingsViewModel()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        bindViewModel()
        viewModel.load()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    // MARK: - Setup UI
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Holdings"

        view.addSubview(tableView)
        view.addSubview(summaryView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        summaryView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            summaryView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            summaryView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            summaryView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: summaryView.topAnchor)

        ])
    }


    private func setupTableView() {
        tableView.register(
            HoldingCell.self,
            forCellReuseIdentifier: HoldingCell.reuseIdentifier
        )

        tableView.dataSource = self

        tableView.separatorStyle = .singleLine
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 72
        tableView.keyboardDismissMode = .onDrag
    }

    // MARK: - Binding

    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            guard let self else { return }

            self.tableView.reloadData()

            if let summary = self.viewModel.summary {
                self.summaryView.configure(summary: summary)
            }
        }
        
        viewModel.onError = { [weak self] message in
            guard let self else { return }
            self.showErrorAlert(message: message)
        }
    }
    
    private func showErrorAlert(message: String) {

        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(title: "OK", style: .default)
        )

        present(alert, animated: true)
    }

}

// MARK: - UITableViewDataSource

extension HoldingsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.holdings.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: HoldingCell.reuseIdentifier,
            for: indexPath
        ) as? HoldingCell else {
            return UITableViewCell()
        }

        let holding = viewModel.holdings[indexPath.row]
        cell.configure(with: holding)
        return cell
    }
}
