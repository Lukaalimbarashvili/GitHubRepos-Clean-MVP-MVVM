//
//  RepositoryModel.swift
//  GitHubRepositories
//
//  Created by Luka Alimbarashvili on 13.02.26.
//

struct Repository {
    let name: String
    let owner: Owner
    let description: String?
    let stargazersCount: Int
    let forksCount: Int
    let language: String?
}

struct Owner {
    let login: String
    let avatarUrl: String
}
