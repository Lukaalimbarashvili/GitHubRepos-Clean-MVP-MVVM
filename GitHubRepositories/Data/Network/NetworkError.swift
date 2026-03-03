//
//  NetworkError.swift
//  GitHubRepositories
//
//  Created by Luka Alimbarashvili on 31.12.25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case noData
    case decodingError(Error)
    case other(Error)
    
    var message: String {
        switch self {
        case .invalidURL: "The URL is invalid."
        case .invalidResponse: "Invalid server response."
        case .noData: "No data received from server."
        case .decodingError(let error): "Failed to decode data: \(error.localizedDescription)"
        case .other(let error): "Unexpected error: \(error.localizedDescription)"
        }
    }
}
