//
//  MovieDetailsTableViewCell.swift
//  MovieDB
//
//  Created by Maar Babu on 1/26/20.
//  Copyright © 2020 Maar Babu. All rights reserved.
//

import UIKit

class MovieDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var tableHeight: NSLayoutConstraint!
    private var movieDetails: MovieDetails?
    private let numberOfRows = 3
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: MovieDetailsDataTableViewCell.className, bundle: nil), forCellReuseIdentifier: MovieDetailsDataTableViewCell.reuseIdentifier)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func fill(with movieDetails: MovieDetails) {
        self.movieDetails = movieDetails
        tableView.reloadData()
    }
    
}

extension MovieDetailsTableViewCell: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var title: String = .empty
        var desc: String = .empty
        switch indexPath.row {
        case 0:
            title = LocalString("MovieDetailsOriginalTitle")
            desc = movieDetails?.originalTitle ?? .empty
        case 1:
            title = LocalString("MovieDetailsOverview")
            desc = movieDetails?.overview ?? .empty
        case 2:
            title = LocalString("MovieDetailsReleaseDate")
            desc = movieDetails?.releaseDate ?? .empty
        default:
            break
        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: MovieDetailsDataTableViewCell.reuseIdentifier, for: indexPath) as? MovieDetailsDataTableViewCell{
            cell.fill(with: title, desc: desc)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.indexPathsForVisibleRows?.last?.row{
            tableHeight.constant = tableView.contentHeight
        }
    }
}
