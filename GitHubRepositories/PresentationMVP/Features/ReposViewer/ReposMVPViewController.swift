//
//  ReposMVPViewController.swift
//  GitHubRepositories
//
//  Created by Luka Alimbarashvili on 03.03.26.
//

import UIKit

final class ReposMVPViewController: UIViewController {

    private let presenter: ReposMVPPresenterProtocol
    private var tableView: UITableView!
    private let sectionSpacing: CGFloat = 16
    private let username: String

    init(presenter: ReposMVPPresenterProtocol, username: String) {
        self.presenter = presenter
        self.username = username
        super.init(nibName: nil, bundle: nil)
        presenter.attachView(self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Repositories (MVP)"
        view.backgroundColor = .systemBackground
        configureTableView()
        presenter.load(username: username)
    }

    private func configureTableView() {
        tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.register(
            RepoMVPTableViewCell.self,
            forCellReuseIdentifier: RepoMVPTableViewCell.reuseIdentifier
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

extension ReposMVPViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        presenter.rows.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: RepoMVPTableViewCell.reuseIdentifier,
                for: indexPath
            ) as? RepoMVPTableViewCell
        else {
            return UITableViewCell()
        }

        cell.configure(with: presenter.rows[indexPath.section])
        return cell
    }
}

extension ReposMVPViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        sectionSpacing
    }
}

extension ReposMVPViewController: ReposMVPViewProtocol {

    func renderLoading() {
        DispatchQueue.main.async {
            self.tableView?.reloadData()
        }
    }

    func renderContent() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func renderError(_ message: String) {
        print(message) // TODO: present error state
    }

    func updateRow(at index: Int) {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: index)
            if let cell = self.tableView.cellForRow(at: indexPath) as? RepoMVPTableViewCell {
                cell.showLastCommitText(
                    self.presenter.rows[index].lastCommitSha ?? "Git Repository is empty"
                )
            }
        }
    }
}

