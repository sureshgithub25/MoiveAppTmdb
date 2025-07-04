//
//  SearchView.swift
//  Movie
//
//  Created by Suresh Kumar on 18/05/25.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()

    var body: some View {
        NavigationView {
            
            List(viewModel.results, id: \.id) { movie in
                NavigationLink(destination: MovieDetailView(movie: movie)) {
                    MovieRowView(movie: movie)
                }
            }
            .searchable(text: $viewModel.searchText)
            .navigationTitle("Search")
        }
    }
}
