//
//  GetLastCommitRepository.swift
//  GitHubRepositories
//
//  Created by Luka Alimbarashvili on 13.02.26.
//

protocol GetLastCommitRepository {
    func getLastCommit(username: String, repo: String, completion: @escaping (Result<[Commit], DomainError>) -> Void)
}
