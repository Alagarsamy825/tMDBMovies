//
//  MoviesTableViewCell.swift
//  tMDBMovies
//
//  Created by Alagarsamy on 07/02/26.
//

import UIKit

class MoviesTableViewCell: UITableViewCell {
    
    private var movieId: Int?
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var ratingView: StarRatingView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(_ movies: Movie) {
        movieId = movies.id
        titleLabel.text = movies.title
        ratingView.rating = (movies.voteAverage ?? 0.0) / 2.0
        movieImageView.loadTMDBImage(path: movies.posterPath ?? "placeholder" , placeholder: UIImage(named: "placeholder"))
        durationLabel.text = movies.runtimeText
        updateFavoriteIcon()
    }
    
    @IBAction func favoriteTapped(_ sender: UIButton) {
        guard let id = movieId else { return }
        FavoritesManager.shared.toggleFavorite(movieId: id)
        updateFavoriteIcon()
    }
    
    private func updateFavoriteIcon() {
        guard let id = movieId else { return }
        let isFav = FavoritesManager.shared.isFavourite(movieId: id)
        let imageName = isFav ? "heart.fill" : "heart"
        favouriteButton.setImage(UIImage(systemName: imageName), for: .normal)
        favouriteButton.tintColor = isFav ? UIColor.systemRed : UIColor.lightGray
    }
}
