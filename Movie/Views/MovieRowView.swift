//
//  MovieRowView.swift
//  Movie
//
//  Created by Suresh Kumar on 18/05/25.
//

import SwiftUI

struct MovieRowView: View {
    let movie: Movie

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w200\(movie.posterPath ?? "")")) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .frame(width: 80, height: 120)
            .cornerRadius(8)

            VStack(alignment: .leading, spacing: 6) {
                Text(movie.title)
                    .font(.headline)
                Text(movie.overview)
                    .font(.caption)
                    .lineLimit(3)
            }
        }
        .padding(.horizontal)
    }
}
