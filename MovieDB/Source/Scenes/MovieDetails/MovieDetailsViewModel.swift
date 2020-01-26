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
}

protocol MovieDetailsViewModelOutputs: ErrorViewModelProtocol {
    var movieDidLoad: Observable<Void> { get }
    func getMovieDetails() -> MovieDetails?
}

class MovieDetailsViewModel {
    
    let onError: BehaviorRelay<Network.Status> = .init(value: .error)
    let _movieDidLoad: PublishRelay<Void> = PublishRelay<Void>()
    let movieDidLoad: Observable<Void>
    private var movieDetails: MovieDetails?
    private var id: Int?
    
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
            self?._movieDidLoad.accept(())
        }, fail: self.standardFailBlock)
    }
}

// MARK: - MovieDetailsViewModelOutputs
extension MovieDetailsViewModel: MovieDetailsViewModelOutputs {
    func getMovieDetails() -> MovieDetails?{
        return movieDetails
    }
    
}

// MARK: - MovieDetailsViewModelType
extension MovieDetailsViewModel: MovieDetailsViewModelType {
    
    var inputs: MovieDetailsViewModelInputs { get { return self } }
    var outputs: MovieDetailsViewModelOutputs { get { return self } }
    
}

