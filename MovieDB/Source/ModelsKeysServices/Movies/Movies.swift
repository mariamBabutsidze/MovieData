//
//  Movies.swift
//  MovieDB
//
//  Created by Maar Babu on 1/25/20.
//  Copyright © 2020 Maar Babu. All rights reserved.
//

import Foundation

class Movies: Decodable{
    
    var page: Int
    var totalResults: Int
    var totalPages: Int
    var results: [Movie]
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: Key.Coding.self)
        self.page = try values.decodeIfPresent(Int.self, forKey: .page) ?? .zero
        self.totalResults = try values.decodeIfPresent(Int.self, forKey: .total_results) ?? .zero
        self.totalPages = try values.decodeIfPresent(Int.self, forKey: .total_pages) ?? .zero
        self.results = try values.decodeIfPresent([Movie].self, forKey: .results) ?? []
    }
}


class Movie: Decodable{
    
    var id: Int
    var iconUrl: URL?
    var isFavourite: Bool
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: Key.Coding.self)
        self.id = try values.decodeIfPresent(Int.self, forKey: .id) ?? .zero
        self.isFavourite = try MovieDetails.containsMovieDetail(id: id)
        self.iconUrl = URL(string: "\(Path.load)\(try values.decodeIfPresent(String.self, forKey: .poster_path) ?? .empty)")
    }
    
}
