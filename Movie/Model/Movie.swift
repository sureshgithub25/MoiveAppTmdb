//
//  Movie.swift
//  Movie
//
//  Created by Suresh Kumar on 18/05/25.
//

import Foundation

struct Movie: Identifiable, Decodable, Equatable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let releaseDate: String?
    let voteAverage: Double?
    let backdropPath: String?
    var isBookMarked: Bool = false
    var category: String = ""

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case backdropPath = "backdrop_path"
    }

    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }
}

