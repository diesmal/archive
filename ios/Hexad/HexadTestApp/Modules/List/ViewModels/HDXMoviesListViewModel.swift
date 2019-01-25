//
//  HDXMoviesListViewModel.swift
//  HexadTestApp
//
//  Created by di on 31.12.18.
//  Copyright © 2018 Ilia Nikolaenko. All rights reserved.
//

import Foundation
import RxSwift

class HDXMoviesListViewModel : HDXListViewModel, HDXRandomRatingViewModel {
    let router: HDXListRouter
    var movieService = HDXMovieService()
    var itemMoved = PublishSubject<(from: Int, to: Int?)>()
    var randomRatingService: HDXRandomRatingService?
    var itemsCount: Int {
        return self.movieService.itemsCount
    }
    
    init(router: HDXListRouter) {
        self.router = router
        self.randomRatingService = HDXRandomRatingService(viewModel: self)
    }
    
    func title(index: Int) -> String {
        return self.movieService.movie(at: index)?.name ?? "?"
    }
    
    func rating(index: Int) -> String {
        guard let rating = self.movieService.movie(at: index)?.rating else {
            return "?"
        }
        return String(format: "%.1f", rating)
    }
    
    func onItem(index: Int) {
        guard let movie = self.movieService.movie(at: index) else {
            return
        }
        
        self.router.showRateMovieAlert(name: movie.name ?? "?") { [unowned self] (vote) in
            if let vote = vote {
                self.addVote(vote, index: index)
            }
        }
    }
    
    func addVote(_ vote: Int, index: Int) {
        guard let movie = self.movieService.movie(at: index) else {
            return
        }
        
        self.movieService.addRating(vote: vote, index: index)
        
        var newIndex: Int? = index
        if let currentMovie = self.movieService.movie(at: index) {
            if currentMovie != movie {
                newIndex = self.movieService.getIndex(movie: movie)
            }
        }
        
        self.itemMoved.onNext((from: index, to: newIndex))
    }
    
    func onRandomRating() {
        guard let isRunning = self.randomRatingService?.isRunning else {
            Log.error("Random rating service does not exist")
            return
        }
        
        if isRunning {
            self.randomRatingService?.stop()
        } else {
            self.randomRatingService?.start()
        }
    }
}
