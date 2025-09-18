//
//  FavoritesManager.swift
//  NASA-APOD
//
//  Created by Felipe Almeida on 18/09/25.
//

import Foundation
import Combine

class FavoritesManager {
    static let shared = FavoritesManager()
    
    private let favoritesKey = "apod_favorites"
    let favoritesDidChange = PassthroughSubject<Void, Never>()
    
    private(set) var favoriteDates: Set<String>

    private init() {
        if let savedFavorites = UserDefaults.standard.array(forKey: favoritesKey) as? [String] {
            self.favoriteDates = Set(savedFavorites)
        } else {
            self.favoriteDates = []
        }
    }

    func isFavorite(date: String) -> Bool {
        favoriteDates.contains(date)
    }

    func toggleFavorite(date: String) {
        if isFavorite(date: date) {
            favoriteDates.remove(date)
        } else {
            favoriteDates.insert(date)
        }
        save()
        favoritesDidChange.send(())
    }
    
    func reset() {
        self.favoriteDates = []
        save()
    }

    private func save() {
        UserDefaults.standard.set(Array(favoriteDates), forKey: favoritesKey)
    }
}
