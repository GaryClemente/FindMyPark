//
//  SearchView.swift
//  FindMyPark
//
//  Created by Gary Clemente on 12/1/25.
//

import SwiftUI

class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var recentSearches: [String] = []

    private let key = "recent_searches"

    init() {
        loadRecentSearches()
    }

    func loadRecentSearches() {
        recentSearches = UserDefaults.standard.stringArray(forKey: key) ?? []
    }

    func addSearch() {
        let trimmed = searchText.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }

        if !recentSearches.contains(trimmed) {
            recentSearches.insert(trimmed, at: 0)

            if recentSearches.count > 10 {
                recentSearches.removeLast()
            }

            UserDefaults.standard.set(recentSearches, forKey: key)
        }
    }
}

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()

    var body: some View {
        VStack(alignment: .leading) {

            TextField("Search…", text: $viewModel.searchText, onCommit: {
                viewModel.addSearch()
            })
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)

            if !viewModel.recentSearches.isEmpty {
                Text("Recent Searches")
                    .font(.headline)
                    .padding(.horizontal)

                List {
                    ForEach(viewModel.recentSearches, id: \.self) { item in
                        Button {
                            viewModel.searchText = item
                        } label: {
                            Text(item)
                        }
                    }
                }
            }

            Spacer()
        }
        .navigationTitle("Search")
    }
}
