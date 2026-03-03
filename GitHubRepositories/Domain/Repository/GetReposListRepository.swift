//
//  GetReposListRepository.swift
//  GitHubRepositories
//
//  Created by Luka Alimbarashvili on 13.02.26.
//

protocol GetReposListRepository {
    func getReposList(username: String, completion: @escaping (Result<[Repository], DomainError>) -> Void)
}
