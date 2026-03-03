//
//  ReposViewModel.swift
//  GitHubRepositories
//
//  Created by Luka Alimbarashvili on 03.03.26.
//

import Foundation

protocol ReposViewModelProtocol: AnyObject {
    var onStateChanged: ((ReposScreenState) -> Void)? { get set }
    var onRowUpdated: ((_ index: Int, _ row: RepoCellViewModel) -> Void)? { get set }
    var rows: [RepoCellViewModel] { get }
    func load(username: String)
}

final class ReposViewModel: ReposViewModelProtocol {

    var onStateChanged: ((ReposScreenState) -> Void)?
    var onRowUpdated: ((Int, RepoCellViewModel) -> Void)?

    private(set) var rows: [RepoCellViewModel] = []
    private let useCase: GetReposWithLastCommitUseCaseProtocol

    init(useCase: GetReposWithLastCommitUseCaseProtocol) {
        self.useCase = useCase
    }

    func load(username: String) {
        onStateChanged?(.loading)

        useCase.execute(
            username: username,
            onInitialRepos: { [weak self] items in
                guard let self else { return }
                let mapped = items.map { self.mapToRow($0, isLoading: true) }
                DispatchQueue.main.async {
                    self.rows = mapped
                    self.onStateChanged?(.content(mapped))
                }
            },
            onRepoUpdated: { [weak self] index, item in
                guard let self else { return }
                let row = self.mapToRow(item, isLoading: false)
                DispatchQueue.main.async {
                    guard self.rows.indices.contains(index) else { return }
                    self.rows[index] = row
                    self.onRowUpdated?(index, row)
                }
            },
            onFailure: { [weak self] error in
                DispatchQueue.main.async {
                    self?.onStateChanged?(.error(String(describing: error)))
                }
            }
        )
    }

    private func mapToRow(_ item: RepoWithLastCommit, isLoading: Bool) -> RepoCellViewModel {
        let repo = item.repository

        return RepoCellViewModel(
            title: repo.name,
            owner: repo.owner.login,
            description: repo.description ?? "No description",
            starsText: "⭐ \(repo.stargazersCount)",
            forksText: "🍴 \(repo.forksCount)",
            languageText: repo.language.map { "💻 \($0)" },
            avatarURL: repo.owner.avatarUrl,
            lastCommitSha: item.lastCommitSha,
            isLoadingCommit: isLoading
        )
    }
}

