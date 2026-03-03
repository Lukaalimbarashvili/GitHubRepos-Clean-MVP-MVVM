//
//  GithubApiConstants.swift
//  GitHubRepositories
//
//  Created by Luka Alimbarashvili on 31.12.25.
//

import Foundation

 // MARK: - GitHub API URLs

/// Contains GitHub API endpoints.
/// Helps create URLs for fetching repositories and commits for a user.
struct GitHubAPI {
    static let baseURL = "https://api.github.com"
    
    static func repos(for username: String) -> URL? {
        URL(string: "\(baseURL)/users/\(username)/repos")
    }
    
    static func commits(for username: String, repo: String) -> URL? {
        URL(string: "\(baseURL)/repos/\(username)/\(repo)/commits")
    }
}
