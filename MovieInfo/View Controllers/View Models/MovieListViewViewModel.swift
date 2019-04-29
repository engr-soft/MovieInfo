//
//  MovieDetailsViewViewModel.swift
//  MovieInfo
//
//  Created by Syed Hashmi on 4/29/19.
//  Copyright © 2019 24i All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MovieListViewViewModel {
    var endpoint: Endpoint = .popular
    var lastPage:Int = 1
    var totalPages:Int = 0
    var totalResults:Int = 0
    private let movieService: BackendServices
    private let disposeBag = DisposeBag()
    
    init(endpoint: Endpoint, movieService: BackendServices) {
        self.movieService = movieService
        self.endpoint = endpoint
        self.fetchMovies(page: 1)
    }
    func fetchIfRequired(lastMovieIndex: Int){
        if lastMovieIndex == _movies.value.count-1 && (lastPage < totalPages){
            self.self.fetchMovies(page: lastPage + 1)
        }
    }
    private let _movies = BehaviorRelay<[Movie]>(value: [])
    private let _isFetching = BehaviorRelay<Bool>(value: false)
    private let _error = BehaviorRelay<String?>(value: nil)
    
    var isFetching: Driver<Bool> {
        return _isFetching.asDriver()
    }
    
    var movies: Driver<[Movie]> {
        return _movies.asDriver()
    }
    
    var error: Driver<String?> {
        return _error.asDriver()
    }
    
    var hasError: Bool {
        return _error.value != nil
    }
    
    var numberOfMovies: Int {
        return _movies.value.count
    }
    
    func viewModelForMovie(at index: Int) -> MovieViewViewModel? {
        guard index < _movies.value.count else {
            return nil
        }
        return MovieViewViewModel(movie: _movies.value[index])
    }
    
    func viewModelForMovieDetial(at index: Int) -> MovieDetailCellViewViewModel? {
        guard index < _movies.value.count else {
            return nil
        }
        return MovieDetailCellViewViewModel(movie: _movies.value[index])
    }
    
    private func fetchMovies(page:Int = 1) {
        if page == 1{
            self._movies.accept([])
        }
        self._isFetching.accept(true)
        self._error.accept(nil)
        
        movieService.fetchMovies(from: endpoint, params: ["page":"\(page)"], successHandler: {[weak self] (response) in
            self?._isFetching.accept(false)
            self?.totalPages = response.totalPages
            self?.lastPage = response.page
        debugPrint(response.results)
//            self?._movies.accept(self?._movies.value ?? [] + response.results)
            self?._movies.acceptAppending(response.results)
//            self?._movies.accept(response.results)
        }) { [weak self] (error) in
            self?._isFetching.accept(false)
            self?._error.accept(error.localizedDescription)
        }
    }
    
}
