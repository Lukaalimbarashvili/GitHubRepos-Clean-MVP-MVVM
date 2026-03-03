//
//  ReposScreenState.swift
//  GitHubRepositories
//
//  Created by Luka Alimbarashvili on 03.03.26.
//

enum ReposScreenState {
    case idle
    case loading
    case content([RepoCellViewModel])
    case error(String)
}

