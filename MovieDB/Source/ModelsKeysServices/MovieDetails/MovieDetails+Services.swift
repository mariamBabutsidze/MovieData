//
//  MovieDetails+Services.swift
//  MovieDB
//
//  Created by Maar Babu on 1/26/20.
//  Copyright © 2020 Maar Babu. All rights reserved.
//

import Foundation
import CoreData

extension MovieDetails{
    
    static func load(id: Int, success: @escaping (MovieDetails?) -> Void, fail: Network.FailBlock)
    {
        var userInfo: [CodingUserInfoKey: Any] = [:]
        if let key = CodingUserInfoKey.managedObjectContext {
            userInfo[key] = CoreDataManager.shared.context
        }
        let path = "\(Key.Path.load)\(id)"
        do{
            if let movieDetails = try MovieDetails.fetchSavedMovieDetail(id: id){
                movieDetails.isFavourite = true
                success(movieDetails)
            } else{
                Network.jsonRequest(path: path, type: MovieDetails.self, userInfo: userInfo, success: { movieDetails in
                    success(movieDetails)
                }, fail: fail)
            }
        }
        catch{ }
    }
    
    static func save(movieDetails: MovieDetails) throws {
        CoreDataManager.shared.context.insert(movieDetails)
        try CoreDataManager.shared.context.save()
    }
    
    static func fetchSavedMovieDetail(id: Int) throws -> MovieDetails? {
        let fetchRequest = NSFetchRequest<MovieDetails>(entityName: MovieDetails.className)
        fetchRequest.predicate = NSPredicate(format: "id == \(id)")
        let movieDetail: [MovieDetails] = try CoreDataManager.shared.context.fetch(fetchRequest)
        return movieDetail.first
    }
    
    static func deleteMovieDetail(id: Int) throws{
        let fetchRequest = NSFetchRequest<MovieDetails>(entityName: MovieDetails.className)
        let predicate = NSPredicate(format: "id == \(id)")
        fetchRequest.predicate = predicate
        let movieDetails: [MovieDetails] = try CoreDataManager.shared.context.fetch(fetchRequest)
        if !movieDetails.isEmpty{
            CoreDataManager.shared.context.delete(movieDetails.first!)
        }
        try CoreDataManager.shared.context.save()
    }
    
    static func fetchSavedMovieDetail(id: Int) throws -> [MovieDetails] {
        let fetchRequest = NSFetchRequest<MovieDetails>(entityName: MovieDetails.className)
        let movieDetail: [MovieDetails] = try CoreDataManager.shared.context.fetch(fetchRequest)
        return movieDetail
    }
    
    static func containsMovieDetail(id: Int) throws -> Bool{
        let fetchRequest = NSFetchRequest<MovieDetails>(entityName: MovieDetails.className)
        fetchRequest.predicate = NSPredicate(format: "id == \(id)")
        let movieDetail: [MovieDetails] = try CoreDataManager.shared.context.fetch(fetchRequest)
        return !movieDetail.isEmpty
    }
}
