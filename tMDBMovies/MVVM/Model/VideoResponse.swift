//
//  VideoResponse.swift
//  tMDBMovies
//
//  Created by Alagarsamy on 07/02/26.
//

import Foundation

struct VideoResponse: Decodable {
    let id: Int?
    let results: [Video]
}


struct Video: Decodable {
    let id: String?
    let name: String?
    let key: String?
    let site: String?
    let type: String?
    let official: Bool?
    let publishedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case key
        case site
        case type
        case official
        case publishedAt = "published_at"
    }
}
