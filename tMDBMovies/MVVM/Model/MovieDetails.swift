//
//  MovieDetails.swift
//  tMDBMovies
//
//  Created by Alagarsamy on 07/02/26.
//

import Foundation

struct MovieDetails: Codable {

    let title: String?
    let plot: String?
    let genres: [Genre]
    let duration: Int?
    let rating: Double?

    enum CodingKeys: String, CodingKey {
        case title
        case plot = "overview"
        case genres
        case duration = "runtime"
        case rating = "vote_average"
    }
}

struct Genre: Codable {
    let id: Int?
    let name: String?
}
