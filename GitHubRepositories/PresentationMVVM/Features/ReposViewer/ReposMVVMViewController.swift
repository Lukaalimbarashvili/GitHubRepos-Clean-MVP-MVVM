//
//  ReposMVVMViewController.swift
//  GitHubRepositories
//
//  Created by Luka Alimbarashvili on 03.03.26.
//

import UIKit

final class ReposMVVMViewController: UIViewController {

    private let viewModel: ReposViewModelProtocol
    private var tableView: UITableView!
    private let sectionSpacing: CGFloat = 16

    init(viewModel: ReposViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureTableView()
        bind()
        viewModel.load(username: "mralexgray")
    }

    private func bind() {
        viewModel.onStateChanged = { [weak self] state in
            guard let self else { return }

            switch state {
            case .idle:
                break
            case .loading:
                break
            case .content:
                self.tableView.reloadData()
            case .error(let message):
                print(message) // TODO: show error state
            }
        }

        viewModel.onRowUpdated = { [weak self] index, row in
            guard let self else { return }

            let indexPath = IndexPath(row: 0, section: index)
            if let cell = self.tableView.cellForRow(at: indexPath) as? RepoMVVMTableViewCell {
                cell.showLastCommitText(row.lastCommitSha ?? "Git Repository is empty")
            }
        }
    }

    private func configureTableView() {
        tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.register(
            RepoMVVMTableViewCell.self,
            forCellReuseIdentifier: RepoMVVMTableViewCell.reuseIdentifier
        )
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 110
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionFooterHeight = sectionSpacing
        tableView.allowsSelection = false

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ])
    }
}

extension ReposMVVMViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.rows.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: RepoMVVMTableViewCell.reuseIdentifier,
                for: indexPath
            ) as? RepoMVVMTableViewCell
        else {
            return UITableViewCell()
        }

        let row = viewModel.rows[indexPath.section]
        cell.configure(with: row)
        return cell
    }
}

extension ReposMVVMViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        sectionSpacing
    }
}

