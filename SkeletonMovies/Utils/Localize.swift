//
//  Localize.swift
//  SkeletonMovies
//
//  Created by Jesus Calleja Rodriguez on 15/10/23.
//

import Foundation

struct Localize {

    func get(_ key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
}
