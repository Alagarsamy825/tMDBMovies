//
//  NetworkManager.swift
//  tMDBMovies
//
//  Created by Alagarsamy on 07/02/26.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func request<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
