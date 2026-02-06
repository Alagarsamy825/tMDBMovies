//
//  Movie.swift
//  tMDBMovies
//
//  Created by Alagarsamy on 07/02/26.
//

import Foundation

struct MovieResponse: Decodable {
    let results: [Movie]
}
struct Movie: Decodable {

    let id: Int?
    let title: String?
    let overview: String?
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let voteAverage: Double?
    let voteCount: Int?
    let popularity: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case popularity
    }
}

