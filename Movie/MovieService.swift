//
//  MovieService.swift
//  Movie
//
//  Created by Suresh Kumar on 13/05/25.
//

import Foundation

enum MovieEndpoint: String {
    case popular = "/3/movie/popular"
    case nowPlaying = "/3/movie/now_playing"
    case search = "/3/search/movie"
}

final class MovieService {
    private let baseURL = "https://api.themoviedb.org"
    private let token = "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2NTg4YWFkZGE4OTY5MDk3N2E0MDE2ZTgxNDFjNTVlNyIsIm5iZiI6MTc0NzA1MjUzNC44OTQsInN1YiI6IjY4MjFlN2Y2NWUwNDc3YTY0MTVhMmM4ZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.YJtIdG0w5BHboe6voFPKtlKfeZ1k1OP93sb3ef8OCwA"

    func fetchMovies(endpoint: MovieEndpoint,
                     page: Int = 1,
                     completion: @escaping (Result<MovieResponse, NetworkError>) -> Void) {
        let queryItems = [
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "\(page)")
        ]

        let request = NKRequest(
            baseURL: baseURL,
            path: endpoint.rawValue,
            method: .GET,
            queryItems: queryItems,
            headers: [
                "accept": "application/json",
                "Authorization": token
            ]
        )

        NetworkManager.shared.performRequest(request: request, responseType: MovieResponse.self) { result in
            completion(result)
        }
    }

    func searchMovies(query: String, page: Int = 1,
                      completion: @escaping (Result<MovieResponse, NetworkError>) -> Void) {
        let queryItems = [
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "page", value: "\(page)")
        ]

        let request = NKRequest(
            baseURL: baseURL,
            path: MovieEndpoint.search.rawValue,
            method: .GET,
            queryItems: queryItems,
            headers: [
                "accept": "application/json",
                "Authorization": token
            ]
        )

        NetworkManager.shared.performRequest(request: request, responseType: MovieResponse.self) { result in
            completion(result)
        }
    }
}
