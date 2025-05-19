//
//  MovieDetailView.swift
//  Movie
//
//  Created by Suresh Kumar on 18/05/25.
//

import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    @State var isBookMarked: Bool = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(movie.backdropPath ?? "")")) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray
                }
                .frame(height: 250)

                Text(movie.title)
                    .font(.largeTitle)
                    .padding(.top)

                Text("\(movie.releaseDate ?? "") | Rating \(String(format: "%.1f", movie.voteAverage ?? 0.0))")
                    .font(.subheadline)
                    .padding(.vertical, 2)

                Text(movie.overview)
                    .padding(.top, 8)
            }
            .padding()
        }
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    toggleBookmark()
                }) {
                    Image(systemName: isBookMarked ? "bookmark.fill" : "bookmark")
                }
                .accessibilityLabel(isBookMarked ? "Remove Bookmark" : "Add Bookmark")
            }
        }
        .onAppear {
           let movies = CoreDataManager.shared
                .objectExists(ofType: SavedMovie.self,
                              matchingID: String(movie.id),
                              withKey: "id").objects
            
            if let movie = movies.first {
                self.isBookMarked = movie.isBookmarked
            }
        }
    }
    
    private func toggleBookmark() {
        MovieViewModel.toggleBookmark(for: movie)
        isBookMarked.toggle()
    }
}
