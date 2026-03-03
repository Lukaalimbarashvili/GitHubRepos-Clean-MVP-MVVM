//
//  NetworkManager.swift
//  GitHubRepositories
//
//  Created by Luka Alimbarashvili on 31.12.25.
//

import Foundation

/// Singleton responsible for making network requests.
/// Handles response validation and decoding JSON into Decodable types.
/// Returns results via a completion handler with `NetworkError` for failure cases.
final class NetworkManager {

    func request<T: Decodable>(
        url: URL?,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard let url else {
            completion(.failure(.invalidURL))
            return
        }

        let request = URLRequest(url: url)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.other(error)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }

            guard 200..<300 ~= httpResponse.statusCode else {
                completion(.failure(.invalidResponse))
                return
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            do {
                let decoder = JSONDecoder()
                // Automatically converts snake_case JSON keys to camelCase Swift properties
                // I was about to write CodingKeys for everything when I discovered this, and it’s awesome! 😄
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decoded = try decoder.decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }

        task.resume()
    }
}
