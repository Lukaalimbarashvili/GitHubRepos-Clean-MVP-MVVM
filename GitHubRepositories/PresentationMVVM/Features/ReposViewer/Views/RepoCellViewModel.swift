//
//  RepoCellViewModel.swift
//  GitHubRepositories
//
//  Created by Luka Alimbarashvili on 03.03.26.
//

struct RepoCellViewModel {
    let title: String
    let owner: String
    let description: String
    let starsText: String
    let forksText: String
    let languageText: String?
    let avatarURL: String
    let lastCommitSha: String?
    let isLoadingCommit: Bool
}

