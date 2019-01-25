//
//  HDXListViewController.swift
//  HexadTestApp
//
//  Created by di on 30.12.18.
//  Copyright © 2018 Ilia Nikolaenko. All rights reserved.
//

import UIKit
import RxSwift

fileprivate let MovieCellIdentifier = "HDXMovieTableViewCell"
fileprivate let MovieCellHeight: CGFloat = 64

class HDXListViewController : HDXBaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var viewModel: HDXListViewModel?
    
    override var assembly: HDXAssembly? {
        return HDXListAssembly()
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func bindUI() {
        self.viewModel?.itemMoved
            .observeOn(MainScheduler())
            .subscribe(onNext: { [unowned self] (move) in
                self.itemWasMoved(from: move.from, to: move.to)
            }).disposed(by: self.disposableBag)
    }
    
    func itemWasMoved(from: Int, to: Int?) {
        guard let to = to else {
            self.tableView.reloadData()
            return
        }
        
        let atIndex = IndexPath(row: from, section: 0)
        
        if (from != to) {
            let toIndex = IndexPath(row: to, section: 0)
            
            let atCell = self.tableView.cellForRow(at: atIndex)
            let toCell = self.tableView.cellForRow(at: toIndex)
            
            self.updateBackgroundColor(cell: atCell, at: toIndex)
            self.updateBackgroundColor(cell: toCell, at: atIndex)
            
            CATransaction.begin()
            self.tableView.beginUpdates()
            CATransaction.setCompletionBlock {
                self.tableView.reloadData()
            }
            self.tableView.moveRow(at: atIndex, to: toIndex)
            tableView.endUpdates()
            CATransaction.commit()
        } else {
            self.tableView.reloadRows(at: [atIndex], with: .automatic)
        }
    }
    
    func updateBackgroundColor(cell: UITableViewCell?, at indexPath: IndexPath) {
        cell?.contentView.backgroundColor = (indexPath.row % 2 == 0) ? UIColor.darkGray : UIColor.gray
    }
    
    //MARK: Actions
    
    @IBAction func onRandomRating(_ sender: UIBarButtonItem) {
        self.viewModel?.onRandomRating()
    }
    
    //MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.itemsCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieCellIdentifier, for: indexPath)
        
        if let movieCell = cell as? HDXMovieTableViewCell {
            movieCell.numberLabel.text = "\(indexPath.row + 1)."
            movieCell.titleLabel.text = self.viewModel?.title(index: indexPath.row)
            movieCell.ratingLabel.text = self.viewModel?.rating(index: indexPath.row)
        }
        
        self.updateBackgroundColor(cell: cell, at: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MovieCellHeight
    }
    
    //MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel?.onItem(index: indexPath.row)
    }
}
