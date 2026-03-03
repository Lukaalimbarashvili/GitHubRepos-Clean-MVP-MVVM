//
//  GetLastCommitRepositoryImpl.swift
//  GitHubRepositories
//
//  Created by Luka Alimbarashvili on 13.02.26.
//

class GetLastCommitRepositoryImpl: GetLastCommitRepository {
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func getLastCommit(username: String, repo: String, completion: @escaping (Result<[Commit], DomainError>) -> Void) {
        let url = GitHubAPI.commits(for: username, repo: repo)
        
        networkManager.request(url: url) { (result: Result<[CommitDTO], NetworkError>) in
            switch result {
            case .success(let commitDTOs):
                let commits = commitDTOs.map { Commit(sha: $0.sha) }
                completion(.success(commits))
            case .failure(let error):
                completion(.failure(error.asDomainError))
            }
        }
    }    
}
