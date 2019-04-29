//
//  MovieListViewController.swift
//  MovieInfo
//
//  Created by Syed Hashmi on 4/29/19.
//  Copyright © 2019 24i All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MovieListViewController: UIViewController {
    private var selectedRowIndex = -1
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var infoLabel: UILabel!
    
    var movieListViewViewModel: MovieListViewViewModel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUIDataFromService()
        setupTableView()
    }
    
    private func fetchUIDataFromService(){
        movieListViewViewModel = MovieListViewViewModel(endpoint: .popular, movieService: BackendServices.shared)
        movieListViewViewModel.movies.drive(onNext: {[unowned self] (_) in
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        movieListViewViewModel.isFetching.drive(activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        movieListViewViewModel.error.drive(onNext: {[unowned self] (error) in
            self.infoLabel.isHidden = !self.movieListViewViewModel.hasError
            self.infoLabel.text = error
        }).disposed(by: disposeBag)
    }
    
    
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: "MovieCell")
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueID = segue.identifier, segueID == StoryBoardConstants.segueShowMovieDetails.rawValue{
            if let vc = segue.destination as? MovieDetailsViewController{
                vc.movieDetailCellViewViewModel = self.movieListViewViewModel.viewModelForMovieDetial(at: selectedRowIndex)
            }
        }
    }
}

extension MovieListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieListViewViewModel.numberOfMovies
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        if let viewModel = movieListViewViewModel.viewModelForMovie(at: indexPath.row) {
            cell.configure(viewModel: viewModel)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.movieListViewViewModel.fetchIfRequired(lastMovieIndex: indexPath.row)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRowIndex = indexPath.row
        self.performSegue(withIdentifier: StoryBoardConstants.segueShowMovieDetails.rawValue, sender: self)
        
    }
}
