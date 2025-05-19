//
//  MovieResponse.swift
//  Movie
//
//  Created by Suresh Kumar on 18/05/25.
//

import Foundation

struct MovieResponse: Decodable {
    let page: Int
    let results: [Movie]
    let total_pages: Int
    let total_results: Int
}
