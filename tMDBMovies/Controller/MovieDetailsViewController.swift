//
//  MovieDetailsViewController.swift
//  tMDBMovies
//
//  Created by Alagarsamy on 07/02/26.
//

import UIKit
import WebKit

class MovieDetailsViewController: UIViewController {
    
    private var viewModel: MovieDetailViewModel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var trailerContainerView: UIView!
    @IBOutlet weak var plotLabel: UILabel!
    
    private var webView: WKWebView?
    
    func configure(movieId: Int) {
        viewModel = MovieDetailViewModel(movieId: movieId)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewModel.fetchDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    private func bindViewModel() {
        viewModel.onDataUpdated = { [weak self] in
            self?.updateUI()
        }
    }
    
    private func updateUI() {
        guard let detail = viewModel.movieDetail else { return }
        
        titleLabel.text = detail.title
        ratingLabel.text = "⭐️ \((detail.rating ?? 0.0) / 2.0)"
        durationLabel.text = viewModel.durationText
        genresLabel.text = viewModel.genresText
        plotLabel.text = "Overview\n\(detail.plot)"
        
        if let trailerKey = viewModel.trailerKey {
            playTrailer(videoKey: trailerKey)
        }
    }
    
    private func playTrailer(videoKey: String) {
        let embedURLString = "\(Constants.youtubeURL)\(videoKey)"
        guard let url = URL(string: embedURLString) else { return }
        
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        
        let webView = WKWebView(frame: trailerContainerView.bounds, configuration: config)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.scrollView.isScrollEnabled = false
        
        trailerContainerView.addSubview(webView)
        webView.load(URLRequest(url: url))
        
        self.webView = webView
    }
}
