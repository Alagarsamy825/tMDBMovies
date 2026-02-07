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
    let posterPath: String?
    let backdropPath: String?
    let voteAverage: Double?
    
    var runtimeText: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title = "original_title"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case voteAverage = "vote_average"
    }
}

