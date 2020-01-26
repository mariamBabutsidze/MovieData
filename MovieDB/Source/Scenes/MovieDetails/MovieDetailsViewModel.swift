//
//  MovieDetailsViewModel.swift
//  MovieDB
//
//  Created by Maar Babu on 1/26/20.
//  Copyright © 2020 Maar Babu. All rights reserved.
//

import RxSwift
import RxCocoa

protocol MovieDetailsViewModelType {
    
    var inputs: MovieDetailsViewModelInputs { get }
    var outputs: MovieDetailsViewModelOutputs { get }
    
}

protocol MovieDetailsViewModelInputs {
    func loadMovieDetails()
    func changeFavourite()
}

protocol MovieDetailsViewModelOutputs: ErrorViewModelProtocol {
    var movieDidLoad: Observable<Void> { get }
    func getMovieDetails() -> MovieDetails?
    func numberOfRows() -> Int
}

class MovieDetailsViewModel {
    
    let onError: BehaviorRelay<Network.Status> = .init(value: .error)
    let _movieDidLoad: PublishRelay<Void> = PublishRelay<Void>()
    let movieDidLoad: Observable<Void>
    private var movieDetails: MovieDetails?
    private var id: Int?
    private let numberOfRow = 2
    private var isFav = false
    
    init(id: Int)
    {
        self.id = id
        self.movieDidLoad = self._movieDidLoad.asObservable()
    }
    
}

// MARK: - MovieDetailsViewModelInputs
extension MovieDetailsViewModel: MovieDetailsViewModelInputs {
    func loadMovieDetails() {
        guard let id = id else {
            return
        }
        MovieDetails.load(id: id, success: { [weak self] movieDetails in
            self?.movieDetails = movieDetails
            self?.isFav = movieDetails?.isFavourite ?? false
            self?._movieDidLoad.accept(())
            }, fail: self.standardFailBlock)
    }
    
    func changeFavourite(){
        guard let id = id else { return }
        guard let movieDetails = movieDetails else { return }
        NotificationCenter.default.post(name: .favouriteChanged, object: nil, userInfo: ["id": id])
        isFav.toggle()
        do{
            if isFav{
                try MovieDetails.save(movieDetails: movieDetails)
            } else{
                try MovieDetails.deleteMovieDetail(id: id)
            }
        } catch{ }
    }
}

// MARK: - MovieDetailsViewModelOutputs
extension MovieDetailsViewModel: MovieDetailsViewModelOutputs {
    func getMovieDetails() -> MovieDetails?{
        return movieDetails
    }
    
    func numberOfRows() -> Int{
        return numberOfRow
    }
}

// MARK: - MovieDetailsViewModelType
extension MovieDetailsViewModel: MovieDetailsViewModelType {
    
    var inputs: MovieDetailsViewModelInputs { get { return self } }
    var outputs: MovieDetailsViewModelOutputs { get { return self } }
    
}

