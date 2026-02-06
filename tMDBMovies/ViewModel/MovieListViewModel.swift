//
//  MovieListViewModel.swift
//  tMDBMovies
//
//  Created by Alagarsamy on 07/02/26.
//

import Foundation

final class MovieListViewModel {
    private(set) var movies: [Movie] = [] {
        didSet {
            onMoviesUpdated?()
        }
    }
    
    var onMoviesUpdated: (() -> Void)?
    var onError: ((Error) -> Void)?
    var onLoading: ((Bool) -> Void)?
    
    func fetchPopularMovies() {
        let urlString = "\(Constants.baseURL)\(Constants.popular)api_key=\(Constants.api_key)"
        guard let url = URL(string: urlString) else { return }
        
        NetworkManager.shared.request(url: url) { [weak self] (result: Result<MovieResponse, Error>) in
            DispatchQueue.main.async {
                self?.onLoading?(false)
                switch result {
                case .success(let response):
                    self?.movies = response.results
                    self?.onMoviesUpdated?()
                case .failure(let error):
                    self?.onError?(error)
                }
            }
            
        }
    }
    
    func numberOfRows() -> Int {
        movies.count
    }
    
    func movie(at index: Int) -> Movie {
        movies[index]
    }
}
