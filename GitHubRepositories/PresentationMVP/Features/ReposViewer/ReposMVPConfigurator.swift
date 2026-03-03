//
//  ReposMVPConfigurator.swift
//  GitHubRepositories
//
//  Created by Luka Alimbarashvili on 03.03.26.
//

import UIKit

final class ReposMVPConfigurator {

    static func getReposVC(username: String = "mralexgray") -> UIViewController {
        let networkManager = NetworkManager()
        let reposRepository = GetReposListRepositoryImpl(networkManager: networkManager)
        let commitsRepository = GetLastCommitRepositoryImpl(networkManager: networkManager)
        let useCase = GetReposWithLastCommitUseCase(
            reposRepository: reposRepository,
            commitsRepository: commitsRepository
        )

        let presenter = ReposMVPPresenter(useCase: useCase)
        return ReposMVPViewController(presenter: presenter, username: username)
    }
}

