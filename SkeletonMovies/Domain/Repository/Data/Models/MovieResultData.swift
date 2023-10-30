//
//  MovieResultData.swift
//  SkeletonMovies
//
//  Created by Jesus Calleja Rodriguez on 30/10/23.
//

struct MovieResultData: Codable {
    let title: String
    let overview: String
    let releaseDate: String
    let posterPath: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case overview
        case releaseDate = "release_date"
        case posterPath = "poster_path"
    }
    
}
