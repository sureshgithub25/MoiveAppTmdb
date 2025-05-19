//
//  BookMarkView.swift
//  Movie
//
//  Created by Suresh Kumar on 18/05/25.
//

import Foundation
import SwiftUI

struct BookmarkView: View {
    @State private var bookmarkedMovies: [Movie] = []

    var body: some View {
        NavigationView {
            List(bookmarkedMovies, id: \ .id) { movie in
                MovieRowView(movie: movie)
            }
            .navigationTitle("Bookmarked Movies")
            .onAppear {
                bookmarkedMovies = MovieViewModel.fetchBookmarkedMovies()
            }
        }
    }
}
