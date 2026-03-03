//
//  NetworkError+DomainError.swift
//  GitHubRepositories
//
//  Created by Luka Alimbarashvili on 18.02.26.
//

extension NetworkError {
    var asDomainError: DomainError {
        switch self {
        case .invalidURL:
            return .invalidInput
        case .invalidResponse:
            return .unavailable
        case .noData:
            return .notFound
        case .decodingError:
            return .corruptedData
        case .other:
            return .unknown
        }
    }
}

