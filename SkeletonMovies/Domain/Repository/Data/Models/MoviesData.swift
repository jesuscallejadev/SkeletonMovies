//
//  MoviesData.swift
//  SkeletonMovies
//
//  Created by Jesus Calleja Rodriguez on 15/10/23.
//

struct MoviesData: Codable {
    let totalPages: Int
    let results: [MovieResultData]
    
    enum CodingKeys: String, CodingKey {
        case totalPages = "total_pages"
        case results
    }
}
