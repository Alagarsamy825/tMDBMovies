//
//  ViewController.swift
//  tMDBMovies
//
//  Created by Alagarsamy on 07/02/26.
//

import UIKit

class MoviesViewController: UIViewController {
    
    private let viewModel = MovieListViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindViewModel()
        viewModel.fetchPopularMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func setupTableView() {
        tableView.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: SectionHeaderView.identifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func bindViewModel() {
        viewModel.onMoviesUpdated = { [weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel.onMovieUpdated = { [weak self] index in
            guard let self = self else { return }
            let indexPath = IndexPath(row: index, section: 0)
            
            if self.tableView.indexPathsForVisibleRows?.contains(indexPath) == true {
                self.tableView.reloadRows(at: [indexPath], with: .none)
            }
        }
        
        viewModel.onError = { [weak self] message in
            let alert = UIAlertController(
                title: "Error",
                message: message.localizedDescription,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
    }
}

extension MoviesViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.movieTableViewCellIdentifier, for: indexPath) as! MoviesTableViewCell
        let movie = viewModel.movies[indexPath.row]
        cell.configure(movie)
        cell.selectionStyle = .none
        if movie.runtimeText == nil {
            viewModel.fetchRuntime(for: movie.id ?? 0, at: indexPath.row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionHeaderView.identifier) as? SectionHeaderView
        header?.titleLabel.text = Constants.popularMovieTitle
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let movie = viewModel.movie(at: indexPath.row)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: Constants.movieDetailsViewControllerIdentifier) as? MovieDetailsViewController
        vc?.navigationItem.title = movie.title
        vc?.configure(movieId: movie.id ?? 0)
        navigationController?.pushViewController(vc!, animated: true)
    }
}

extension MoviesViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchMovies(query: searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        viewModel.fetchPopularMovies()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.placeholder = Constants.typeMovieName
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.placeholder = Constants.searchMovie
    }
}
