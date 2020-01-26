//
//  MovieDetailsViewController.swift
//  MovieDB
//
//  Created by Maar Babu on 1/26/20.
//  Copyright © 2020 Maar Babu. All rights reserved.
//

import UIKit
import RxSwift

class MovieDetailsViewController: UIViewController {
    
    private var viewModel: MovieDetailsViewModelType!
    private let disposeBag = DisposeBag()
    @IBOutlet private weak var tableView: UITableView!
    
    static func load(with viewModel: MovieDetailsViewModelType) -> Self
    {
        let ep = self.loadFromStoryboard()
        ep.viewModel = viewModel
        return ep
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindObservables()
        loadMovie()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func loadMovie(){
        startLoader()
        viewModel.inputs.loadMovieDetails()
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: MovieDetailsHeaderViewCell.className, bundle: nil), forCellReuseIdentifier: MovieDetailsHeaderViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: MovieDetailsTableViewCell.className, bundle: nil), forCellReuseIdentifier: MovieDetailsTableViewCell.reuseIdentifier)
    }
    
    private func bindObservables(){
        viewModel.outputs.onError.skip(1).subscribe(onNext: self.standardFailBlock).disposed(by: disposeBag)
        viewModel.outputs.movieDidLoad.subscribe(onNext: { [weak self] in
            self?.stopLoader()
            self?.tableView.reloadData()
        }).disposed(by: disposeBag)
    }

    private func showPhotos(photoDatas: [PhotoViewerManager.PhotoData], initialIndex: Int, forImageView imageView: UIImageView?){
        PhotoViewerManager().present(on: self, photoDatas: photoDatas, initialPhotoIndex: initialIndex, parentView: self.view, imageView: imageView)
    }
}

extension MovieDetailsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputs.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            if let cell = tableView.dequeueReusableCell(withIdentifier: MovieDetailsHeaderViewCell.reuseIdentifier, for: indexPath) as? MovieDetailsHeaderViewCell{
                cell.delegate = self
                if let movieDetails = viewModel.outputs.getMovieDetails(){
                    cell.fill(with: movieDetails)
                }
                return cell
            }
        } else{
            if let cell = tableView.dequeueReusableCell(withIdentifier: MovieDetailsTableViewCell.reuseIdentifier, for: indexPath) as? MovieDetailsTableViewCell{
                if let movieDetails = viewModel.outputs.getMovieDetails(){
                    cell.fill(with: movieDetails)
                }
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return tableView.frame.height
        }
        else{
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .zero
    }
}

extension MovieDetailsViewController: MovieDetailsHeaderViewCellDelegate{
    func loadPhotoViewer(photoDatas: [PhotoViewerManager.PhotoData], initialIndex: Int, forImageView imageView: UIImageView?) {
        showPhotos(photoDatas: photoDatas, initialIndex: initialIndex, forImageView: imageView)
    }
    
    func dismiss() {
        stopLoader()
        navigationController?.popViewController(animated: true)
    }
    
    func favouriteClicked() {
        
    }
    
}
