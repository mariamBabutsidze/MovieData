//
//  MovieDetals.swift
//  MovieDB
//
//  Created by Maar Babu on 1/26/20.
//  Copyright © 2020 Maar Babu. All rights reserved.
//

import Foundation
import CoreData

class MovieDetails: NSManagedObject, Decodable{
    
    @NSManaged var id: Int
    @NSManaged var title: String
    @NSManaged var iconURLValue: String
    @NSManaged var overview: String
    @NSManaged var originalTitle: String
    @NSManaged var releaseDate: String
    @NSManaged var vote: Double
    @NSManaged var voteCount: Int
    
    var iconURL: URL? { get { return URL(string: iconURLValue)}}
    var isFavourite: Bool = false
    
    required convenience init(from decoder: Decoder) throws
    {
        guard let key = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[key] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: Self.className, in: managedObjectContext) else {
            throw NSError(domain: "Couldn't instantiate Movie Detail NSManagedObject Entity", code: .zero, userInfo: nil)
        }
        
        self.init(entity: entity, insertInto: nil)
        let values = try decoder.container(keyedBy: Key.Coding.self)
        self.id = try values.decodeIfPresent(Int.self, forKey: .id) ?? .zero
        self.title = try values.decodeIfPresent(String.self, forKey: .title) ?? .empty
        self.iconURLValue = "\(Key.Path.loadIcon)\(try values.decodeIfPresent(String.self, forKey: .poster_path) ?? .empty)"
        self.overview = try values.decodeIfPresent(String.self, forKey: .overview) ?? .empty
        self.originalTitle = try values.decodeIfPresent(String.self, forKey: .original_title) ?? .empty
        self.releaseDate = try values.decodeIfPresent(String.self, forKey: .release_date) ?? .empty
        self.vote = try values.decodeIfPresent(Double.self, forKey: .vote_average) ?? .zero
        self.voteCount = try values.decodeIfPresent(Int.self, forKey: .vote_count) ?? .zero
        self.isFavourite = false
    }
    
    func createCopy(movieDetais: MovieDetails) -> MovieDetails{
        let newMovie = MovieDetails.init(entity: NSEntityDescription.entity(forEntityName: Self.className, in: CoreDataManager.shared.context)!, insertInto: nil)
        newMovie.id = movieDetais.id
        newMovie.title = movieDetais.title
        newMovie.overview = movieDetais.overview
        newMovie.iconURLValue = movieDetais.iconURLValue
        newMovie.originalTitle = movieDetais.originalTitle
        newMovie.releaseDate = movieDetais.releaseDate
        newMovie.vote = movieDetais.vote
        newMovie.voteCount = movieDetais.voteCount
        newMovie.isFavourite = movieDetais.isFavourite
        return newMovie
    }
}
