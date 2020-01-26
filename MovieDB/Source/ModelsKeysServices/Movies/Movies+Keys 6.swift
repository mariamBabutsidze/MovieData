//
//  Movies+Keys.swift
//  MovieDB
//
//  Created by Maar Babu on 1/25/20.
//  Copyright © 2020 Maar Babu. All rights reserved.
//

import Foundation

extension Movies{
    
    struct Key{
        enum Coding: String, CodingKey{
            case page
            case total_results
            case total_pages
            case results
        }
        
        struct Path {
            
            static let load = "3/discover/movie"
            
        }
    }
    
    struct ParsingKeys{
        enum Parse: String{
            case page
            case Longitude
        }
    }
}


extension Movie{
    
    struct Key{
        enum Coding: String, CodingKey{
            case id
            case poster_path
        }
    }
    
    struct Path {
        
        static let load = "https://image.tmdb.org/t/p/w342"
        
    }
}
