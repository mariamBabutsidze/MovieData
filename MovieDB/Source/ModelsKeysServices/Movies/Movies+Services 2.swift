//
//  Movies+Services.swift
//  MovieDB
//
//  Created by Maar Babu on 1/25/20.
//  Copyright © 2020 Maar Babu. All rights reserved.
//

import Foundation


extension Movies{
    
    static func load(page: Int, count: Int?, average: Int?, success: @escaping (Movies?) -> Void, fail: Network.FailBlock)
    {
        var body: [String: Any] = [:]
        body[ParsingKeys.Parse.page.rawValue] = page
        body[ParsingKeys.Parse.vote_count.rawValue] = count
        body[ParsingKeys.Parse.vote_average.rawValue] = average
        Network.jsonRequest(path: Key.Path.load, body: body, type: Movies.self, success: { movies in
            success(movies)
        }, fail: fail)
    }
}
