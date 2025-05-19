//
//  HomeListView.swift
//  Movie
//
//  Created by Suresh Kumar on 18/05/25.
//

import SwiftUI

struct HomeListView: View {
    @StateObject private var viewModel = MovieViewModel()
    @State private var selectedCategory: MovieCategory = .trending
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Category", selection: $selectedCategory) {
                    Text("Trending").tag(MovieCategory.trending)
                    Text("Now Playing").tag(MovieCategory.nowPlaying)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                List(moviesForSelectedCategory(), id: \.id) { movie in
                    NavigationLink(destination: MovieDetailView(movie: movie)) {
                        MovieRowView(movie: movie)
                            .onAppear {
                                if movie == moviesForSelectedCategory().last {
                                    viewModel.loadNextPageIfNeeded(currentItem: movie,
                                                                   for: selectedCategory)
                                }
                            }
                    }
                }
                .listStyle(PlainListStyle())
                
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationTitle("Movies")
            .navigationBarItems(trailing:
                NavigationLink(destination: BookmarkView()) {
                    Text("Saved Movies")
                }
            )
            .onAppear {
                viewModel.fetchMovies(category: selectedCategory)
            }
            .onChange(of: selectedCategory) { newCategory in
                viewModel.fetchMovies(category: newCategory)
            }
        }
    }

    private func moviesForSelectedCategory() -> [Movie] {
        switch selectedCategory {
        case .trending: return viewModel.trendingMovies
        case .nowPlaying: return viewModel.nowPlayingMovies
        }
    }
}

