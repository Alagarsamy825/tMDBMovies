//
//  Constants.swift
//  tMDBMovies
//
//  Created by Alagarsamy on 07/02/26.
//

import Foundation

struct Constants {
    static let baseURL = "https://api.themoviedb.org/3"
    static let popular = "popular?"
    static let videos = "videos?"
    static let api_key = "0ca73cf8151431a0ceb8b7afe32ae05b"
    
    static let posterBaseURL = "https://image.tmdb.org/t/p/"
    static let posterSize = "w342"
    
    static let popularMovieTitle = "Popular Movies"
    static let searchMovie = "Search Movie"
    static let typeMovieName = "Type movie name..."
    
    static let youtubeURL = "https://www.youtube.com/watch?v="
    
    static let favouriteKey = "favorite_movie_ids"
    
    static let movieTableViewCellIdentifier = "MoviesTableViewCell"
    static let movieDetailsViewControllerIdentifier = "MovieDetailsViewController"
}
