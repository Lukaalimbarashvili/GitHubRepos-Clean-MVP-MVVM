//
//  ReposMVPPresenter.swift
//  GitHubRepositories
//
//  Created by Luka Alimbarashvili on 03.03.26.
//

import Foundation

protocol ReposMVPViewProtocol: AnyObject {
    func renderLoading()
    func renderContent()
    func renderError(_ message: String)
    func updateRow(at index: Int)
}

protocol ReposMVPPresenterProtocol: AnyObject {
    var rows: [RepoMVPRowState] { get }
    func attachView(_ view: ReposMVPViewProtocol)
    func load(username: String)
}

final class ReposMVPPresenter: ReposMVPPresenterProtocol {

    weak var view: ReposMVPViewProtocol?
    private let useCase: GetReposWithLastCommitUseCaseProtocol

    private(set) var rows: [RepoMVPRowState] = []

    init(useCase: GetReposWithLastCommitUseCaseProtocol) {
        self.useCase = useCase
    }

    func attachView(_ view: ReposMVPViewProtocol) {
        self.view = view
    }

    func load(username: String) {
        view?.renderLoading()

        useCase.execute(
            username: username,
            onInitialRepos: { [weak self] initial in
                guard let self else { return }
                DispatchQueue.main.async {
                    self.rows = initial.map {
                        self.makeRowState(
                            repository: $0.repository,
                            lastCommitSha: nil,
                            isLoadingCommit: true
                        )
                    }
                    self.view?.renderContent()
                }
            },
            onRepoUpdated: { [weak self] index, item in
                guard let self else { return }
                DispatchQueue.main.async {
                    guard self.rows.indices.contains(index) else { return }
                    self.rows[index] = self.makeRowState(
                        repository: item.repository,
                        lastCommitSha: item.lastCommitSha,
                        isLoadingCommit: false
                    )
                    self.view?.updateRow(at: index)
                }
            },
            onFailure: { [weak self] error in
                DispatchQueue.main.async {
                    self?.view?.renderError(String(describing: error))
                }
            }
        )
    }

    private func makeRowState(
        repository: Repository,
        lastCommitSha: String?,
        isLoadingCommit: Bool
    ) -> RepoMVPRowState {
        RepoMVPRowState(
            title: repository.name,
            owner: repository.owner.login,
            description: repository.description ?? "No description",
            starsText: "⭐ \(repository.stargazersCount)",
            forksText: "🍴 \(repository.forksCount)",
            languageText: repository.language.map { "💻 \($0)" },
            avatarURL: repository.owner.avatarUrl,
            lastCommitSha: lastCommitSha,
            isLoadingCommit: isLoadingCommit
        )
    }
}
