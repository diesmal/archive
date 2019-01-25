//
//  HDXListViewModel.swift
//  HexadTestApp
//
//  Created by di on 31.12.18.
//  Copyright © 2018 Ilia Nikolaenko. All rights reserved.
//

import Foundation
import RxSwift

protocol HDXListViewModel {
    var itemsCount: Int { get }
    var itemMoved: PublishSubject<(from: Int, to: Int?)> { get }
    func title(index: Int) -> String
    func rating(index: Int) -> String
    func onItem(index: Int)
    func onRandomRating()
}
