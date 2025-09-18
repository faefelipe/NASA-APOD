//
//  APODDetailViewModel.swift
//  NASA-APOD
//
//  Created by Felipe Almeida on 18/09/25.
//

import Foundation

class APODDetailViewModel {
    let apod: APOD
    private let favoritesManager = FavoritesManager.shared
    private(set) var isFavorite: Bool
    var onFavoriteStatusChange: ((Bool) -> Void)?
    
    init(apod: APOD) {
        self.apod = apod
        self.isFavorite = favoritesManager.isFavorite(date: apod.date)
    }
    
    func toggleFavorite() {
        favoritesManager.toggleFavorite(date: apod.date)
        self.isFavorite = favoritesManager.isFavorite(date: apod.date)
        onFavoriteStatusChange?(self.isFavorite)
    }
}
