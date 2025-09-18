//
//  FavoritesViewModel.swift
//  NASA-APOD
//
//  Created by Felipe Almeida on 18/09/25.
//

import Foundation
import Combine

@MainActor
class FavoritesViewModel {
    
    private let apiService = APIService()
    private let favoritesManager = FavoritesManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var favoriteAPODs: [APOD] = []
    @Published private(set) var isLoading = false
    
    var onSelectAPOD: ((APOD) -> Void)?
    
    init() {
        favoritesManager.favoritesDidChange
            .sink { [weak self] in
                self?.fetchFavoriteAPODs()
            }
            .store(in: &cancellables)
    }

    func fetchFavoriteAPODs() {
        isLoading = true
        let dates = favoritesManager.favoriteDates
        
        guard !dates.isEmpty else {
            favoriteAPODs = []
            isLoading = false
            return
        }
        
        Task { @MainActor in
            let results = await fetchAPODsConcurrently(for: dates)
            favoriteAPODs = results.sorted { $0.date > $1.date }
            isLoading = false
        }
    }
    
    private func fetchAPODsConcurrently(for dates: Set<String>) async -> [APOD] {
        await withTaskGroup(of: APOD?.self, returning: [APOD].self) { group in
            for date in dates {
                group.addTask { [apiService] in
                    try? await apiService.fetchAPOD(for: date)
                }
            }
            
            var apods: [APOD] = []
            for await result in group {
                if let apod = result {
                    apods.append(apod)
                }
            }
            return apods
        }
    }
    
    func removeFavorite(at index: Int) {
        guard index < favoriteAPODs.count else { return }
        let apodToRemove = favoriteAPODs[index]
        favoritesManager.toggleFavorite(date: apodToRemove.date)
    }
    
    func didSelect(apod: APOD) {
        onSelectAPOD?(apod)
    }
}
