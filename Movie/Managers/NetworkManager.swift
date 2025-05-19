//
//  NetworkManager.swift
//  Movie
//
//  Created by Suresh Kumar on 13/05/25.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noResponse
    case serverError(statusCode: Int)
    case decodingFailed
    case custom(message: String)
    
    var errorDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL encountred"
        case .noResponse:
            return "No Respose recieve from server"
        case .serverError(statusCode: let statusCode):
            return "Server return error with error code: \(statusCode)"
        case .decodingFailed:
            return "Failed to decode the server response"
        case .custom(message: let message):
            return message
        }
    }
}

//enum APIEndPoint {
//    case fetchMovies
//    case fetchMovieDetails
//    
//    var method: HTTPMethod {
//        switch self {
//        case .fetchMovies, .fetchMovieDetails:
//            return .GET
//        }
//    }
//    
//    var urlString: String {
//        switch self {
//        case .fetchMovies:
//            ""
//        case .fetchMovieDetails:
//            ""
//        }
//    }
//}

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func performRequest<T: Decodable>( request: NKRequest,
                                      responseType: T.Type,
                                      completion: @escaping (Result<T, NetworkError>) -> Void) {
        print(request.urlRequest)
        guard let request = request.urlRequest else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse, let data = data else {
                completion(.failure(.noResponse))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.serverError(statusCode: httpResponse.statusCode)))
                return
            }
            
            do {
                let decodeData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodeData))
            } catch {
                completion(.failure(.decodingFailed))
            }
        }.resume()
    }
}
