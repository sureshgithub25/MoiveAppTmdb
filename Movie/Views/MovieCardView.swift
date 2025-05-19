//
//  MovieCardView.swift
//  Movie
//
//  Created by Suresh Kumar on 18/05/25.
//

import Foundation
import SwiftUI

struct MovieCardView: View {
    let movie: Movie

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath ?? "")")) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .frame(width: 120, height: 180)
            .cornerRadius(8)

            Text(movie.title)
                .font(.caption)
                .lineLimit(1)
                .frame(width: 120)
        }
    }
}
