//
//  Movies+Services.swift
//  MovieDB
//
//  Created by Maar Babu on 1/25/20.
//  Copyright © 2020 Maar Babu. All rights reserved.
//

import Foundation


extension Movies{
    
    static func load(page: Int, success: @escaping (Movies?) -> Void, fail: Network.FailBlock)
    {
        var body: [String: Any] = [:]
        body[ParsingKeys.Parse.page.rawValue] = page
        Network.jsonRequest(path: Key.Path.load, body: body, type: Movies.self, success: { movies in
            success(movies)
        }, fail: fail)
    }
}
