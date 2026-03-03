//
//  GetReposListRepositoryImpl.swift
//  GitHubRepositories
//
//  Created by Luka Alimbarashvili on 13.02.26.
//

class GetReposListRepositoryImpl: GetReposListRepository {
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func getReposList(username: String, completion: @escaping (Result<[Repository], DomainError>) -> Void) {
        let url = GitHubAPI.repos(for: username)
        
        networkManager.request(url: url) { (result: Result<[RepositoryDTO], NetworkError>)  in
            switch result {
            case .success(let RepositoryDTO):
                let repository = RepositoryDTO.map { Repository(name: $0.name,
                                                                owner: Owner(login: $0.owner.login, avatarUrl: $0.owner.avatarUrl),
                                                                description: $0.description,
                                                                stargazersCount: $0.stargazersCount,
                                                                forksCount: $0.forksCount,
                                                                language: $0.language) }
                completion(.success(repository))
            case .failure(let failure):
                completion(.failure(failure.asDomainError))
            }
        }
    }
}
