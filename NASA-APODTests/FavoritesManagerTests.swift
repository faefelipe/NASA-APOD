//
//  FavoritesManagerTests.swift
//  NASA-APOD
//
//  Created by Felipe Almeida on 18/09/25.
//

import XCTest
@testable import NASA_APOD

final class FavoritesManagerTests: XCTestCase {
    
    var favoritesManager: FavoritesManager!
    let mockDate = "2024-09-15"

    override func setUp() {
        super.setUp()
        favoritesManager = FavoritesManager.shared
        UserDefaults.standard.removeObject(forKey: "apod_favorites")
        favoritesManager.reset()
    }

    func testAddFavorite() {
        favoritesManager.toggleFavorite(date: mockDate)
        XCTAssertTrue(favoritesManager.isFavorite(date: mockDate), "A data deveria ter sido favoritada")
        XCTAssertEqual(favoritesManager.favoriteDates.count, 1)
    }
    
    func testRemoveFavorite() {
        favoritesManager.toggleFavorite(date: mockDate)
        favoritesManager.toggleFavorite(date: mockDate)
        XCTAssertFalse(favoritesManager.isFavorite(date: mockDate), "A data deveria ter sido removida dos favoritos")
        XCTAssertTrue(favoritesManager.favoriteDates.isEmpty)
    }
    
    func testIsFavorite_ReturnsCorrectStatus() {
        XCTAssertFalse(favoritesManager.isFavorite(date: mockDate))
        favoritesManager.toggleFavorite(date: mockDate)
        XCTAssertTrue(favoritesManager.isFavorite(date: mockDate))
    }
}
