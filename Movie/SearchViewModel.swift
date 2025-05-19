//
//  SearchViewModel.swift
//  Movie
//
//  Created by Suresh Kumar on 18/05/25.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var results: [Movie] = []

    private var cancellables = Set<AnyCancellable>()

    init() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.searchMovies(query: query)
            }
            .store(in: &cancellables)
    }

    func searchMovies(query: String) {
        guard !query.isEmpty else {
            results = []
            return
        }

        let queryItems = [URLQueryItem(name: "query", value: query)]
        let request = NKRequest(baseURL: "https://api.themoviedb.org/3",
                                path: "/search/movie",
                                method: .GET,
                                queryItems: queryItems,
                                headers: [
                                    "accept": "application/json",
                                    "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2NTg4YWFkZGE4OTY5MDk3N2E0MDE2ZTgxNDFjNTVlNyIsIm5iZiI6MTc0NzA1MjUzNC44OTQsInN1YiI6IjY4MjFlN2Y2NWUwNDc3YTY0MTVhMmM4ZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.YJtIdG0w5BHboe6voFPKtlKfeZ1k1OP93sb3ef8OCwA"
                                ])

        NetworkManager.shared.performRequest(request: request,
                                             responseType: MovieResponse.self) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.results = response.results
                case .failure:
                    self?.results = []
                }
            }
        }
    }
}
