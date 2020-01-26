//
//  MoviewListViewController.swift
//  MovieDB
//
//  Created by Maar Babu on 1/25/20.
//  Copyright © 2020 Maar Babu. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit

class MovieListViewController: UIViewController {
    
    private var viewModel: MovieListViewModelType!
    private let disposeBag = DisposeBag()
    
    @IBOutlet private weak var collectionView: UICollectionView!
    private var refreshControlSpinner = UIRefreshControl()
    private let tourCount = 2
    private let insets = 10 * Constants.ScreenFactor
    
    static func load(with viewModel: MovieListViewModelType) -> Self
    {
        let ep = self.loadFromStoryboard()
        ep.viewModel = viewModel
        return ep
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        bindObservables()
        loadMovies()
    }
    
    private func loadMovies(){
        startLoader()
        viewModel.inputs.loadMovies(refresh: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        refreshControlSpinner.tintColor = UIColor.MovieDB.green
        collectionView.contentInset = UIEdgeInsets(top: insets, left: insets, bottom: .zero, right: insets)
        let collectionWidth = view.frame.width - 2 * insets
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumInteritemSpacing = 10 * Constants.ScreenFactor
            let width = (collectionWidth - flowLayout.minimumInteritemSpacing * CGFloat(tourCount - 1))/CGFloat(tourCount)
            flowLayout.itemSize = CGSize(width: width, height: width)
        }
        collectionView.register(UINib.init(nibName: MovieListCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: MovieListCollectionViewCell.reuseIdentifier)
        refreshControlSpinner.addTarget(self, action: #selector(refreshControlValueChanged), for: .valueChanged)
        collectionView.addSubview(refreshControlSpinner)
    }
    
    private func bindObservables(){
        viewModel.outputs.onError.skip(1).subscribe(onNext: self.standardFailBlock).disposed(by: disposeBag)
        viewModel.outputs.moviesDidLoad.subscribe(onNext: { [weak self] in
            self?.stopLoader()
            self?.refreshControlSpinner.endRefreshing()
            self?.collectionView.reloadData()
        }).disposed(by: disposeBag)
    }
    
    @objc private func refreshControlValueChanged()
    {
        viewModel.inputs.loadMovies(refresh: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if viewModel.outputs.numberOfItems() > .zero{
            if collectionView.contentOffset.y > (collectionView.contentSize.height - collectionView.frame.size.height) {
                viewModel.inputs.loadMovies(refresh: false)
            }
        }
    }

}

extension MovieListViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.outputs.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListCollectionViewCell.reuseIdentifier, for: indexPath) as? MovieListCollectionViewCell{
            cell.fill(with: viewModel.outputs.itemAt(index: indexPath))
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = viewModel.outputs.itemAt(index: indexPath)
        let moviewDetails = MovieDetailsViewController.load(with: MovieDetailsViewModel(id: item.id))
        navigationController?.pushViewController(moviewDetails, animated: true)
    }
}

extension MovieListViewController: FilterViewControllerDelegate{
    func changeFilter(type: Filter) {
        viewModel.inputs.changeFilters(type: type)
    }
}
