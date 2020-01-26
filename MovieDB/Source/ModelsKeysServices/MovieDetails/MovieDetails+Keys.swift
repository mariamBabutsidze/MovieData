//
//  MovieDetails+Keys.swift
//  MovieDB
//
//  Created by Maar Babu on 1/26/20.
//  Copyright © 2020 Maar Babu. All rights reserved.
//

import Foundation

extension MovieDetails{
    
    struct Key{
        enum Coding: String, CodingKey{
            case id
            case title
            case poster_path
            case overview
            case original_title
            case release_date
            case vote_average
            case vote_count
        }
        
        struct Path {
            
            static let load = "3/movie/"
            static let loadIcon = "https://image.tmdb.org/t/p/original"
        }
    }
    
    struct ParsingKeys{
        enum Parse: String{
            case movie_id
        }
    }
}
