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
        Network.jsonRequest(path: path, type: MovieDetails.self, userInfo: userInfo, success: { movieDetails in
            success(movieDetails)
        }, fail: fail)
    }
}
