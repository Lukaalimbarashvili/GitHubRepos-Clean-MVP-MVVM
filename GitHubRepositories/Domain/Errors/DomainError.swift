//
//  DomainError.swift
//  GitHubRepositories
//
//  Created by Luka Alimbarashvili on 18.02.26.
//

enum DomainError: Error {
    case unavailable
    case invalidInput
    case notFound
    case corruptedData
    case unknown
}

