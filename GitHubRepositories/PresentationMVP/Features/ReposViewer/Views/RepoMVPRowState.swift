//
//  RepoMVPRowState.swift
//  GitHubRepositories
//
//  Created by Luka Alimbarashvili on 03.03.26.
//

struct RepoMVPRowState {
    let title: String
    let owner: String
    let description: String
    let starsText: String
    let forksText: String
    let languageText: String?
    let avatarURL: String
    var lastCommitSha: String?
    var isLoadingCommit: Bool
}

