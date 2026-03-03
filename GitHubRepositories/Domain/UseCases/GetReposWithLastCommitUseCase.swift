//
//  GetReposWithLastCommitUseCase.swift
//  GitHubRepositories
//
//  Created by Luka Alimbarashvili on 03.03.26.
//

protocol GetReposWithLastCommitUseCaseProtocol {
    func execute(
        username: String,
        onInitialRepos: @escaping ([RepoWithLastCommit]) -> Void,
        onRepoUpdated: @escaping (_ index: Int, _ item: RepoWithLastCommit) -> Void,
        onFailure: @escaping (DomainError) -> Void
    )
}

final class GetReposWithLastCommitUseCase: GetReposWithLastCommitUseCaseProtocol {

    private let reposRepository: GetReposListRepository
    private let commitsRepository: GetLastCommitRepository

    init(
        reposRepository: GetReposListRepository,
        commitsRepository: GetLastCommitRepository
    ) {
        self.reposRepository = reposRepository
        self.commitsRepository = commitsRepository
    }

    func execute(
        username: String,
        onInitialRepos: @escaping ([RepoWithLastCommit]) -> Void,
        onRepoUpdated: @escaping (Int, RepoWithLastCommit) -> Void,
        onFailure: @escaping (DomainError) -> Void
    ) {
        reposRepository.getReposList(username: username) { [weak self] reposResult in
            guard let self else { return }

            switch reposResult {
            case .failure(let error):
                onFailure(error)

            case .success(let repos):
                let initial = repos.map {
                    RepoWithLastCommit(repository: $0, lastCommitSha: nil)
                }
                onInitialRepos(initial)

                for (index, repo) in repos.enumerated() {
                    commitsRepository.getLastCommit(
                        username: repo.owner.login,
                        repo: repo.name
                    ) { commitResult in
                        let sha: String?
                        switch commitResult {
                        case .success(let commits):
                            sha = commits.first?.sha
                        case .failure:
                            sha = nil
                        }

                        let updated = RepoWithLastCommit(
                            repository: repo,
                            lastCommitSha: sha
                        )
                        onRepoUpdated(index, updated)
                    }
                }
            }
        }
    }
}

