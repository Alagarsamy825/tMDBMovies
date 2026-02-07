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
    var onMovieUpdated: ((Int) -> Void)? // index callback

    var onError: ((Error) -> Void)?
    var onLoading: ((Bool) -> Void)?
    
    private var runtimeCache: [Int: String] = [:]
    
    func fetchPopularMovies() {
        let urlString = "\(Constants.baseURL)/movie/\(Constants.popular)api_key=\(Constants.api_key)"
        guard let url = URL(string: urlString) else { return }
        
        NetworkManager.shared.request(url: url) { [weak self] (result: Result<MovieResponse, Error>) in
            DispatchQueue.main.async {
                self?.onLoading?(false)
                switch result {
                case .success(let response):
                    self?.movies = response.results
//                    self?.onMoviesUpdated?()
                case .failure(let error):
                    self?.onError?(error)
                }
            }
            
        }
    }
    
    func searchMovies(query: String) {
        guard !query.isEmpty else {
            fetchPopularMovies()
            return
        }
        
        let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString =
        "\(Constants.baseURL)/search/movie?api_key=\(Constants.api_key)&query=\(encoded)"
        
        guard let url = URL(string: urlString) else { return }
        
        NetworkManager.shared.request(url: url) { (result: Result<MovieResponse, Error>) in
            DispatchQueue.main.async {
                if case let .success(response) = result {
                    self.movies = response.results
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
    
    func fetchRuntime(for movieId: Int, at index: Int) {

        if let cached = runtimeCache[movieId] {
            movies[index].runtimeText = cached
            onMovieUpdated?(index)
            return
        }

        let urlString =
        "\(Constants.baseURL)/movie/\(movieId)?api_key=\(Constants.api_key)"

        guard let url = URL(string: urlString) else { return }

        NetworkManager.shared.request(url: url) {
            (result: Result<MovieDetails, Error>) in

            DispatchQueue.main.async {
                guard case let .success(detail) = result,
                let runtime = detail.duration else { return }

                let text = "\(runtime) min"
                self.runtimeCache[movieId] = text
                self.movies[index].runtimeText = text
                self.onMovieUpdated?(index)
            }
        }
    }
}
