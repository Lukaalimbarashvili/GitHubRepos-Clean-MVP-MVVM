//
//  ReposMVVMConfigurator.swift
//  GitHubRepositories
//
//  Created by Luka Alimbarashvili on 03.03.26.
//

import UIKit

final class ReposMVVMConfigurator {

    static func getReposVC() -> UIViewController {
        let networkManager = NetworkManager()
        let reposRepository = GetReposListRepositoryImpl(networkManager: networkManager)
        let commitsRepository = GetLastCommitRepositoryImpl(networkManager: networkManager)
        let useCase = GetReposWithLastCommitUseCase(
            reposRepository: reposRepository,
            commitsRepository: commitsRepository
        )
        let viewModel = ReposViewModel(useCase: useCase)
        let viewController = ReposMVVMViewController(viewModel: viewModel)
        return viewController
    }
}

