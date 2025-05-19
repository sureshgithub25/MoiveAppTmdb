//
//  MovieListViewModel.swift
//  Movie
//
//  Created by Suresh Kumar on 18/05/25.
//

import Foundation

class MovieListViewModel: ObservableObject {
    @Published var trendingMovies: [Movie] = []
    @Published var nowPlayingMovies: [Movie] = []

    private let baseURL = "api.themoviedb.org"
    private let token = "Bearer <your_token_here>"

    func fetchTrendingMovies() {
        let query: [URLQueryItem] = [URLQueryItem(name: "language", value: "en-US"), URLQueryItem(name: "page", value: "1")]
        let request = NKRequest(baseURL: baseURL,
                                path: "/movie/popular",
                                method: .GET,
                                queryItems: query,
                                headers: ["accept": "application/json", "Authorization": token])

        NetworkManager.shared.performRequest(request: request, responseType: MovieResponse.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.trendingMovies = response.results
                case .failure(let error):
                    print("Error fetching trending movies: \(error.localizedDescription)")
                }
            }
        }
    }

    func fetchNowPlayingMovies() {
        let query: [URLQueryItem] = [URLQueryItem(name: "language", value: "en-US"), URLQueryItem(name: "page", value: "1")]
        let request = NKRequest(baseURL: baseURL,
                                path: "/movie/now_playing",
                                method: .GET,
                                queryItems: query,
                                headers: ["accept": "application/json", "Authorization": token])

        NetworkManager.shared.performRequest(request: request, responseType: MovieResponse.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.nowPlayingMovies = response.results
                case .failure(let error):
                    print("Error fetching now playing movies: \(error.localizedDescription)")
                }
            }
        }
    }
}
