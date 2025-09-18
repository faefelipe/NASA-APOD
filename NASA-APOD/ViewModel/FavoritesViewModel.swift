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
    
    enum State: Equatable {
        case loading
        case success([APOD])
        case empty
        
        static func == (lhs: FavoritesViewModel.State, rhs: FavoritesViewModel.State) -> Bool {
            switch (lhs, rhs) {
            case (.loading, .loading):
                return true
            case (.success(let a), .success(let b)):
                return a == b
            case (.empty, .empty):
                return true
            default:
                return false
            }
        }
    }
    
    private let apiService = APIService()
    private let favoritesManager = FavoritesManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    @Published var state: State = .loading
    
    var onSelectAPOD: ((APOD) -> Void)?
    
    init() {
        favoritesManager.favoritesDidChange
            .sink { [weak self] in
                self?.fetchFavoriteAPODs()
            }
            .store(in: &cancellables)
    }

    func fetchFavoriteAPODs() {
        self.state = .loading
        let dates = favoritesManager.favoriteDates
        
        if dates.isEmpty {
            self.state = .empty
            return
        }
        
        Task {
            let results = await fetchAPODsConcurrently(for: dates)
            
            if results.isEmpty {
                self.state = .empty
            } else {
                let sortedResults = results.sorted { $0.date > $1.date }
                self.state = .success(sortedResults)
            }
        }
    }
    
    private func fetchAPODsConcurrently(for dates: Set<String>) async -> [APOD] {
        return await withTaskGroup(of: APOD?.self, returning: [APOD].self) { group in
            for date in dates {
                group.addTask {
                    return try? await self.apiService.fetchAPOD(for: date)
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
    
    func removeFavorite(at section: Int) {
        guard case .success(var currentAPODs) = self.state, section < currentAPODs.count else {
            return
        }
        
        let apodToRemove = currentAPODs[section]
        favoritesManager.toggleFavorite(date: apodToRemove.date)
    }
    
    func didSelect(apod: APOD) {
        onSelectAPOD?(apod)
    }
}
