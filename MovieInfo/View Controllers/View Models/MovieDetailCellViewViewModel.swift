//
//  MovieDetailViewViewModel.swift
//  MovieInfo
//
//  Created by Syed Hashmi on 4/29/19.
//  Copyright © 2019 24i All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
struct MovieDetailCellViewViewModel {
    
//    private var movie: Movie
    private let _movie = BehaviorRelay<Movie?>(value:nil)
    private let _isFetching = BehaviorRelay<Bool>(value: false)
    private let _error = BehaviorRelay<String?>(value: nil)
    private let _shouldOpenTrailerWithVideoKey = BehaviorRelay<String?>(value: nil)
    
    var shouldOpenTrailerWithVideoKey: Driver<String?> {
        return _shouldOpenTrailerWithVideoKey.asDriver()
    }
    
    var isFetching: Driver<Bool> {
        return _isFetching.asDriver()
    }
    
    var movie: Driver<Movie?> {
        return _movie.asDriver()
    }
    
    var error: Driver<String?> {
        return _error.asDriver()
    }
    
    var hasError: Bool {
        return _error.value != nil
    }
    
    
    
    private static let dateFormatter: DateFormatter = {
        $0.dateStyle = .medium
        $0.timeStyle = .none
        return $0
    }(DateFormatter())
    
    
    init(movie: Movie) {
        _movie.accept(movie)
    }
    
    var title: String {
        guard let thisMovie = _movie.value else {
            return ""
        }
        return thisMovie.title
    }
    
    
    var genres: String {
        guard let thisMovie = _movie.value else {
            return ""
        }
        guard let genresArr = thisMovie.genres else{
            return ""
        }
        let genres = genresArr.compactMap({ $0.name }).map({ "\($0)" }).joined(separator: ",")
        return genres
    }
    
    var trailerURL: URL? {
        guard let thisMovie = _movie.value, let videos = thisMovie.videos else {
            return nil
        }
        for movieVideo in videos.results{
            if let youtubeURL = movieVideo.youtubeURL{
                return youtubeURL
            }
        }
        return nil
    }
    var trailerYoutubeKey: String? {
        guard let thisMovie = _movie.value, let videos = thisMovie.videos else {
            return nil
        }
        for movieVideo in videos.results{
            if let youtubeKey = movieVideo.youtubeKey{
                return youtubeKey
            }
        }
        return nil
    }
    
    var overview: String {
        guard let thisMovie = _movie.value else {
            return ""
        }
        return thisMovie.overview
    }
    
    var posterURL: URL? {
        guard let thisMovie = _movie.value else {
            return nil
        }
        return thisMovie.posterURL
    }
    
    var releaseDate: String {
        guard let thisMovie = _movie.value else {
            return ""
        }
        return MovieDetailCellViewViewModel.dateFormatter.string(from: thisMovie.releaseDate)
    }
    
    var rating: String {
        guard let thisMovie = _movie.value else {
            return ""
        }
        let rating = Int(thisMovie.voteAverage)
        let ratingText = (0..<rating).reduce("") { (acc, _) -> String in
            return acc + "⭐️"
        }
        return ratingText
    }
    
    
    
    public func fetchMovieDetails() {
        guard let thisMovie = _movie.value else {
            return
        }
        self._isFetching.accept(true)
        self._error.accept(nil)
        BackendServices.shared.fetchMovie(id: thisMovie.id, successHandler: {(reponse) in
            self._isFetching.accept(false)
            self._movie.accept(reponse)
            debugPrint(reponse)
        }) {(error) in
            self._isFetching.accept(false)
            self._error.accept(error.localizedDescription)
        }
    }
    
    public func shouldPlayTrailerVideo() {

        if let key = trailerYoutubeKey{
            self._shouldOpenTrailerWithVideoKey.accept(key)
        }
    }
    
/*    func fetchVideos() {
        BackendServices.shared.fetchVideos(movieId: Int , successHandler: {[weak self] (response) in
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
    }*/
}
