//
//  HDXRandomRartingService.swift
//  HexadTestApp
//
//  Created by di on 02.01.19.
//  Copyright © 2019 Ilia Nikolaenko. All rights reserved.
//

import Foundation

protocol HDXRandomRatingViewModel : HDXListViewModel {
    func addVote(_ vote: Int, index: Int)
}

class HDXRandomRatingService {
    
    let listViewModel: HDXRandomRatingViewModel
    var isRunning = false
    
    init (viewModel: HDXRandomRatingViewModel) {
        self.listViewModel = viewModel
    }
    
    func start() {
        self.isRunning = true
        self.addRandomVote()
    }
    
    func stop() {
        self.isRunning = false
    }
    
    private func addRandomVote() {
        guard self.isRunning == true else {
            return
        }
        
        let delay = Double.random(in: 0 ..< 0.5)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            self.addRandomVote()
        })
        
        let randomIndex = Int.random(in: 0 ..< self.listViewModel.itemsCount)
        let randomVote = Int.random(in: 0 ... 5)
        
        self.listViewModel.addVote(randomVote, index: randomIndex)
    }
}
