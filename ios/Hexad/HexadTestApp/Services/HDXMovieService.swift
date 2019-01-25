//
//  HXDMovies.swift
//  HexadTestApp
//
//  Created by di on 30.12.18.
//  Copyright © 2018 Ilia Nikolaenko. All rights reserved.
//

import Foundation

fileprivate let MoviesJSONFileName = "data"
fileprivate let MovieListSeialQueue = "com.nikolaenko.HexadTestApp.moviesListSerialQueue"

class HDXMovieService {
    
    private enum MoviesError : Error {
        case noDataFile
    }
    
    private var moviesList: HDXMoviesList?
    private let moviesListQueue = DispatchQueue(label: MovieListSeialQueue)
    
    var itemsCount: Int {
        return self.moviesList?.movies.count ?? 0
    }
    
    //MARK: Initialization
    init(jsonFile: String = MoviesJSONFileName) {
        self.fillMovesList(from: jsonFile)
    }
    
    //MARK: Public methods
    
    func movie(at index: Int) -> HDXMovie? {
        guard index >= 0 else {
            return nil
        }
        guard let movies = self.moviesList?.movies else {
            return nil
        }
        guard index < movies.count else {
            return nil
        }
        
        return movies[index]
    }
    
    func getIndex(movie: HDXMovie) -> Int? {
        return self.moviesList?.movies.firstIndex(of: movie)
    }
    
    func addRating(vote: Int, index: Int) {
        guard let movie = self.movie(at: index) else {
            return
        }
        let currentRating = movie.rating
        let currentVotes = Double(movie.votes)
        let newVotes = currentVotes + 1
        let newRating = (currentRating * currentVotes + Double(vote)) / newVotes
        
        self.moviesListQueue.sync {
            self.moviesList!.movies[index].rating = newRating
            self.moviesList!.movies[index].votes = Int(newVotes)
            
            if self.isSortNeeded(changedItem: index) {
                self.moviesList!.movies.sort(by: { (leftMovie, rightMovie) -> Bool in
                    return (leftMovie.rating) > (rightMovie.rating)
                })
            }
        }
    }
    
    //MARK: Private methods
    private func isSortNeeded(changedItem: Int) -> Bool {
        guard let changedMovie = self.movie(at: changedItem) else {
            return false
        }
        
        if let prevMovie = self.movie(at: changedItem - 1) {
            if (prevMovie.rating < changedMovie.rating) {
                return true
            }
        }
        
        if let nextMovie = self.movie(at: changedItem + 1) {
            if (nextMovie.rating > changedMovie.rating) {
                return true
            }
        }
        
        return false
    }
    
    private func fillMovesList(from jsonFileName: String) {
        do {
            let newMoviesList = try self.getMovies(from: jsonFileName)
            
            self.moviesListQueue.sync {
                self.moviesList = newMoviesList
            }
            
        } catch HDXMovieService.MoviesError.noDataFile {
            self.moviesList = nil
            Log.error("No data files for movie list found.")
        } catch {
            self.moviesList = nil
            Log.error("Unexpected error: \(error).")
        }
        
        if self.moviesList != nil && self.moviesList?.movies == nil {
            Log.warning("Movie list is empty")
        }
    }
    
    private func getMovies(from jsonFileName: String) throws -> HDXMoviesList {
        
        let jsonDecoder = JSONDecoder()
        let moviesData = try self.getJSONData(fileName: jsonFileName)
        let moviesList = try jsonDecoder.decode(HDXMoviesList.self, from: moviesData)
        
        return moviesList
    }
    
    private func getJSONData(fileName: String) throws -> Data  {
        let bundle = Bundle(for: type(of: self))
        guard let filePath = bundle.url(forResource: fileName, withExtension: "json") else {
            throw HDXMovieService.MoviesError.noDataFile
        }
        let jsonData = try Data(contentsOf: filePath)
        
        return jsonData
    }
    
}
