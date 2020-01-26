//
//  MovieListViewModel.swift
//  MovieDB
//
//  Created by Maar Babu on 1/25/20.
//  Copyright © 2020 Maar Babu. All rights reserved.
//

import RxSwift
import RxCocoa

protocol MovieListViewModelType {
    
    var inputs: MovieListViewModelInputs { get }
    var outputs: MovieListViewModelOutputs { get }
    
}

protocol MovieListViewModelInputs {
    func loadMovies(refresh: Bool)
    func changeFilters(type: Filter)
    func changeMovie(id: Int) -> Bool
}

protocol MovieListViewModelOutputs: ErrorViewModelProtocol {
    var moviesDidLoad: Observable<Void> { get }
    func numberOfItems() -> Int
    func itemAt(index: IndexPath) -> Movie
}

class MovieListViewModel {
    
    let onError: BehaviorRelay<Network.Status> = .init(value: .error)
    let _moviesDidLoad: PublishRelay<Void> = PublishRelay<Void>()
    let moviesDidLoad: Observable<Void>
    private var movies: [Movie] = []
    private var page = 1
    private var loading = false
    private var pageNumber: Int = .zero
    private var filters: [Filter] = []
    private let average = 8
    private let count = 10000
    
    init()
    {
        self.moviesDidLoad = self._moviesDidLoad.asObservable()
    }
    
}

// MARK: - MovieListViewModelInputs
extension MovieListViewModel: MovieListViewModelInputs {
    func loadMovies(refresh: Bool){
        if !loading && (page == 1 || page < pageNumber){
            loading = true
            page = refresh || filters.contains(Filter.favourite) ? 1 : (page + 1)
            let avg : Int? = filters.contains(Filter.topRated) ? average : nil
            let sum : Int? = filters.contains(Filter.popular) ? count : nil
            if refresh != false || !filters.contains(Filter.favourite){
                Movies.load(page: page, count: sum, average: avg, success: { [weak self]  movies in
                    let page = movies?.page
                    let res = movies?.results ?? []
                    if page == 1{
                        self?.pageNumber = movies?.totalResults ?? .zero
                        self?.movies.removeAll()
                    }
                    let fav = self?.filters.contains(Filter.favourite) ?? false
                    var favourites: [MovieDetails] = []
                    if fav && sum == nil && avg == nil{
                        do{
                            favourites = try MovieDetails.fetchSavedMovieDetails()
                            favourites.forEach({
                                self?.movies.append(Movie(id: $0.id, icon: $0.iconURLValue, isFavourite: true))
                            })
                        } catch{ }
                    } else{
                        res.forEach({
                            if (fav && $0.isFavourite) || !fav{
                                self?.movies.append($0)
                            }
                        })
                    }
                    self?.loading = false
                    self?._moviesDidLoad.accept(())
                    }, fail: self.standardFailBlock)
            } else{
                loading = false
            }
        }
    }
    
    func changeFilters(type: Filter){
        if filters.contains(type){
            filters.remove(type)
        } else{
            filters.append(type)
        }
        loadMovies(refresh: true)
    }
    
    func changeMovie(id: Int) -> Bool{
        if let item = movies.filter({ $0.id == id}).first{
            item.isFavourite.toggle()
            if filters.contains(Filter.favourite){
                movies.remove({ $0.id == id })
                return true
            }
            return false
        }
        return false
    }
}

// MARK: - MovieListViewModelOutputs
extension MovieListViewModel: MovieListViewModelOutputs {
    func numberOfItems() -> Int{
        return movies.count
    }
    
    func itemAt(index: IndexPath) -> Movie{
        return movies[index.row]
    }
    
}

// MARK: - MovieListViewModelType
extension MovieListViewModel: MovieListViewModelType {
    
    var inputs: MovieListViewModelInputs { get { return self } }
    var outputs: MovieListViewModelOutputs { get { return self } }
    
}
