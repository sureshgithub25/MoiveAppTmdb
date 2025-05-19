//
//  MovieViewModel.swift
//  Movie
//
//  Created by Suresh Kumar on 18/05/25.
//

import Foundation
import Combine
import CoreData

enum MovieCategory: String {
    case trending = "trending"
    case nowPlaying = "now_playing"
}

class MovieViewModel: ObservableObject {
    @Published var trendingMovies: [Movie] = []
    @Published var nowPlayingMovies: [Movie] = []
    @Published var isLoading = false

    private var trendingPage = 1
    private var nowPlayingPage = 1

    func fetchMovies(category: MovieCategory, page: Int = 1) {
        isLoading = true

        let path = category == .trending ? "/trending/movie/day" : "/movie/now_playing"
        let queryItems = [
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "\(page)")
        ]

        let request = NKRequest(
            baseURL: "https://api.themoviedb.org/3",
            path: path,
            method: .GET,
            queryItems: queryItems,
            headers: [
                "accept": "application/json",
                "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2NTg4YWFkZGE4OTY5MDk3N2E0MDE2ZTgxNDFjNTVlNyIsIm5iZiI6MTc0NzA1MjUzNC44OTQsInN1YiI6IjY4MjFlN2Y2NWUwNDc3YTY0MTVhMmM4ZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.YJtIdG0w5BHboe6voFPKtlKfeZ1k1OP93sb3ef8OCwA"
            ]
        )

        NetworkManager.shared.performRequest(request: request, responseType: MovieResponse.self) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    MovieViewModel.saveOrUpdateMovies(response.results, category: category)
                    
                    switch category {
                    case .trending:
                        if page == 1 {
                            self?.trendingMovies = response.results
                        } else {
                            self?.trendingMovies.append(contentsOf: response.results)
                        }
                        self?.trendingPage = page
                    case .nowPlaying:
                        if page == 1 {
                            self?.nowPlayingMovies = response.results
                        } else {
                            self?.nowPlayingMovies.append(contentsOf: response.results)
                        }
                        self?.nowPlayingPage = page
                    }
                    
                case .failure(let error):
                    if page == 0 {
                        let movie = self?.fetchCachedMovies(for: category)

                        DispatchQueue.main.async {
                            switch category {
                            case .trending:
                                self?.trendingMovies = movie ?? []
                            case .nowPlaying:
                                self?.nowPlayingMovies = movie ?? []
                            }
                        }
                    }
                }
            }
        }
    }

    func loadNextPageIfNeeded(currentItem: Movie, for category: MovieCategory) {
        let movies = category == .trending ? trendingMovies : nowPlayingMovies
        guard let index = movies.firstIndex(where: { $0.id == currentItem.id }) else { return }

        if index >= movies.count - 2 {
            let nextPage = category == .trending ? trendingPage + 1 : nowPlayingPage + 1
            fetchMovies(category: category, page: nextPage)
        }
    }
}

//CoreData logic
extension MovieViewModel {
    
    static func saveOrUpdateMovies(_ movies: [Movie], category: MovieCategory) {
        for movie in movies {
            let movieIdString = "\(movie.id)"
            let (exists, objects) = CoreDataManager.shared.objectExists(
                ofType: SavedMovie.self,
                matchingID: movieIdString,
                withKey: "id"
            )

            if exists, let existing = objects.first {
                // Update existing record
                existing.title = movie.title
                existing.overview = movie.overview
                existing.posterPath = movie.posterPath
                existing.releaseDate = movie.releaseDate
                existing.category = category.rawValue
                // keep existing.isBookmarked as-is
            } else {
                // Create new record
                let newMovie: SavedMovie = CoreDataManager.shared.createObject(ofType: SavedMovie.self)
                newMovie.id = Int64(movie.id)
                newMovie.title = movie.title
                newMovie.overview = movie.overview
                newMovie.posterPath = movie.posterPath
                newMovie.releaseDate = movie.releaseDate
                newMovie.category = category.rawValue
                newMovie.backdropPath = movie.backdropPath
                newMovie.voteAverage = movie.voteAverage ?? 0.0
                newMovie.isBookmarked = false // default unless it's part of bookmarked sync
            }
        }

        CoreDataManager.shared.saveChanges()
    }
    
    static func saveOrUpdateMovie(_ movie: Movie, category: MovieCategory, isBookMarked: Bool = false) {
        
            let movieIdString = "\(movie.id)"
            let (exists, objects) = CoreDataManager.shared.objectExists(
                ofType: SavedMovie.self,
                matchingID: movieIdString,
                withKey: "id"
            )

            if exists, let existing = objects.first {
                // Update existing record
                existing.title = movie.title
                existing.overview = movie.overview
                existing.posterPath = movie.posterPath
                existing.releaseDate = movie.releaseDate
                existing.category = category.rawValue
                existing.isBookmarked = isBookMarked
            } else {
                // Create new record
                let newMovie: SavedMovie = CoreDataManager.shared.createObject(ofType: SavedMovie.self)
                newMovie.id = Int64(movie.id)
                newMovie.title = movie.title
                newMovie.overview = movie.overview
                newMovie.posterPath = movie.posterPath
                newMovie.releaseDate = movie.releaseDate
                newMovie.category = category.rawValue
                newMovie.backdropPath = movie.backdropPath
                newMovie.voteAverage = movie.voteAverage ?? 0.0
                newMovie.isBookmarked = isBookMarked
            }

        CoreDataManager.shared.saveChanges()
    }

// we can fetch movies from coredata as well in batch form but needed time to do it
    func fetchCachedMovies(for category: MovieCategory) -> [Movie] {
        let savedMovies: [SavedMovie] = CoreDataManager.shared.fetchAll(ofType: SavedMovie.self)

        let filtered = savedMovies.filter { $0.category == category.rawValue }

        return filtered.map {
            Movie(id: Int($0.id),
                  title: $0.title ?? "",
                  overview: $0.overview ?? "",
                  posterPath: $0.posterPath ?? "",
                  releaseDate: $0.releaseDate ?? "",
                  voteAverage: $0.voteAverage,
                  backdropPath: $0.backdropPath ?? "",
                  isBookMarked: $0.isBookmarked,
                  category: $0.category ?? ""
            )
        }
    }

   static func fetchBookmarkedMovies() -> [Movie] {
        let savedMovies: [SavedMovie] = CoreDataManager.shared.fetchAll(ofType: SavedMovie.self)

        let bookmarked = savedMovies.filter { $0.isBookmarked }

        return bookmarked.map {
            Movie(id: Int($0.id),
                  title: $0.title ?? "",
                  overview: $0.overview ?? "",
                  posterPath: $0.posterPath ?? "",
                  releaseDate: $0.releaseDate ?? "",
                  voteAverage: $0.voteAverage,
                  backdropPath: $0.backdropPath ?? "",
                  isBookMarked: $0.isBookmarked,
                  category: $0.category ?? ""
            )
        }
    }
    
    static func toggleBookmark(for movie: Movie) {
        let idString = "\(movie.id)"
        let (exists, existing): (Bool, [SavedMovie]) = CoreDataManager.shared.objectExists(ofType: SavedMovie.self, matchingID: idString, withKey: "id")

        guard exists, let saved = existing.first else {
            // If not in Core Data, save first
            saveOrUpdateMovie(movie, category: MovieCategory(rawValue: movie.category) ?? .trending, isBookMarked: true)
            return
        }

        saved.isBookmarked.toggle()
        CoreDataManager.shared.saveChanges()
    }

}

