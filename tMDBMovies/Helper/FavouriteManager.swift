//
//  FavouriteManager.swift
//  tMDBMovies
//
//  Created by Alagarsamy on 07/02/26.
//

import Foundation

final class FavoritesManager {

    static let shared = FavoritesManager()
    private let key = Constants.favouriteKey

    private init() {}

    private var favourites: Set<Int> {
        get {
            guard let ids = UserDefaults.standard.object(forKey: key) as? [Int] else {
                return []
            }
            return Set(ids)
        }
        set {
            UserDefaults.standard.set(Array(newValue), forKey: key)
        }
    }

    func isFavourite(movieId: Int) -> Bool {
        favourites.contains(movieId)
    }

    func toggleFavorite(movieId: Int) {
        var current = favourites
        if current.contains(movieId) {
            current.remove(movieId)
        } else {
            current.insert(movieId)
        }
        favourites = current
    }

    func allFavorites() -> [Int] {
        Array(favourites)
    }
}
