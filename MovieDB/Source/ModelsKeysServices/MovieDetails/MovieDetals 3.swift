//
//  MovieDetals.swift
//  MovieDB
//
//  Created by Maar Babu on 1/26/20.
//  Copyright © 2020 Maar Babu. All rights reserved.
//

import Foundation

class MovieDetails: Decodable{
    
    var title: String
    var iconURL: URL?
    var overview: String
    var originalTitle: String
    var releaseDate: String
    var vote: Double
    var voteCount: Int
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: Key.Coding.self)
        self.title = try values.decodeIfPresent(String.self, forKey: .title) ?? .empty
        self.iconURL = URL(string: "\(Key.Path.loadIcon)\(try values.decodeIfPresent(String.self, forKey: .poster_path) ?? .empty)")
        self.overview = try values.decodeIfPresent(String.self, forKey: .overview) ?? .empty
        self.originalTitle = try values.decodeIfPresent(String.self, forKey: .original_title) ?? .empty
        self.releaseDate = try values.decodeIfPresent(String.self, forKey: .release_date) ?? .empty
        self.vote = try values.decodeIfPresent(Double.self, forKey: .vote_average) ?? .zero
        self.voteCount = try values.decodeIfPresent(Int.self, forKey: .vote_count) ?? .zero
    }
}
