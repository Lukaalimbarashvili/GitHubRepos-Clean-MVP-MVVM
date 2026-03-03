//
//  RepositoryDTO.swift
//  GitHubRepositories
//
//  Created by Luka Alimbarashvili on 13.02.26.
//

struct RepositoryDTO: Decodable {
    let name: String
    let owner: OwnerDTO
    let description: String?
    let stargazersCount: Int
    let forksCount: Int
    let language: String?
}

struct OwnerDTO: Decodable {
    let login: String
    let avatarUrl: String
}
