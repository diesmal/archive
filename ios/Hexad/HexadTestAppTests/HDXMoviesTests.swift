//
//  HDXMoviesTests.swift
//  HexadTestAppTests
//
//  Created by di on 31.12.18.
//  Copyright © 2018 Ilia Nikolaenko. All rights reserved.
//

import XCTest

class HDXMoviesTests: XCTestCase {

    var movieService: HDXMovieService?
    
    override func setUp() {
        self.movieService = HDXMovieService(jsonFile: "test_data")
    }

    override func tearDown() {
        self.movieService = nil
    }

    func testFirstMovieNameIsCorrect() {
        //arrange
        var title: String? = nil
        
        //act
        title = self.movieService?.movie(at: 0)?.name
        
        //assert
        XCTAssertEqual(title, "The Shawshank Redemption")
    }
    
    func testMiddleMovieRatingIsCorrect() {
        //arrange
        var rating: Double? = nil
        
        //act
        rating = self.movieService?.movie(at: 3)?.rating
        
        //assert
        XCTAssertEqual(rating, 2)
    }
    
    func testLastMovieIdIsCorrect() {
        //arrange
        var id: Int? = nil
        
        //act
        id = self.movieService?.movie(at: 5)?.id
        
        //assert
        XCTAssertEqual(id, 23)
    }
    
    func testRankSorting() {
        //arrange
        let movie = self.movieService?.movie(at: 5)
            
        //act
        self.movieService?.addRating(vote: 5, index: 5)
        
        //assert
        XCTAssertEqual(movie, self.movieService?.movie(at: 3))
    }
    
    func testRankCalculation() {
        //act
        self.movieService?.addRating(vote: 2, index: 0)
        
        //assert
        XCTAssertEqual(3.5, self.movieService?.movie(at: 1)?.rating)
    }
    
}
