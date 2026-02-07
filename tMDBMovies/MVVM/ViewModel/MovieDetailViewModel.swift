//
//  MovieDetailViewModel.swift
//  tMDBMovies
//
//  Created by Alagarsamy on 07/02/26.
//

import Foundation

final class MovieDetailViewModel {

    let movieId: Int

    private(set) var movieDetail: MovieDetails? {
        didSet { notifyUpdate() }
    }

    private(set) var trailerKey: String? {
        didSet { notifyUpdate() }
    }

    var onDataUpdated: (() -> Void)?

    init(movieId: Int) {
        self.movieId = movieId
    }

    func fetchDetails() {
        fetchMovieDetails()
        fetchTrailer()
    }

    private func fetchMovieDetails() {
        let urlString =
        "\(Constants.baseURL)/movie/\(movieId)?api_key=\(Constants.api_key)"

        guard let url = URL(string: urlString) else { return }

        NetworkManager.shared.request(url: url) {
            (result: Result<MovieDetails, Error>) in
            DispatchQueue.main.async {
                if case let .success(detail) = result {
                    self.movieDetail = detail
                }
            }
        }
    }

    private func fetchTrailer() {
        let urlString =
        "\(Constants.baseURL)/movie/\(movieId)/videos?api_key=\(Constants.api_key)"

        guard let url = URL(string: urlString) else { return }

        NetworkManager.shared.request(url: url) {
            (result: Result<VideoResponse, Error>) in
            DispatchQueue.main.async {
                if case let .success(response) = result {
                    self.trailerKey = response.results.first {
                        $0.site == "YouTube" && $0.type == "Trailer"
                    }?.key
                }
            }
        }
    }

    private func notifyUpdate() {
        onDataUpdated?()
    }

    // MARK: - UI Helpers

    var durationText: String {
        guard let runtime = movieDetail?.duration else { return "—" }
        return "\(runtime) min"
    }

    var genresText: String {
        movieDetail?.genres.map { $0.name ?? "" }.joined(separator: ", ") ?? ""
    }
}
