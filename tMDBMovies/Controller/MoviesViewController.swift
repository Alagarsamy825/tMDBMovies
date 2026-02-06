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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindViewModel()
        viewModel.fetchPopularMovies()
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MoviesTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func bindViewModel() {
        viewModel.onMoviesUpdated = { [weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel.onLoading = { isLoading in
            print(isLoading ? "Loading..." : "Finished")
        }
        
        print(viewModel.numberOfRows())
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoviesTableViewCell", for: indexPath) as! MoviesTableViewCell
        return cell
    }
}
