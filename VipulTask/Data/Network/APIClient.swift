//
//  APIClient.swift
//  VipulTask
//
//  Created by Vipul Kumar on 15/01/26.
//

import Foundation

protocol APIClientProtocol {
    func get<T: Decodable>(
        url: URL,
        completion: @escaping (Result<T, Error>) -> Void
    )
}

final class APIClient: APIClientProtocol {

    func get<T: Decodable>(
        url: URL,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error {
                completion(.failure(error))
                return
            }

            guard let data else { return }

            do {
                completion(.success(try JSONDecoder().decode(T.self, from: data)))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
