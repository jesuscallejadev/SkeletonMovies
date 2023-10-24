//
//  Movie.swift
//  SkeletonMovies
//
//  Created by Jesus Calleja Rodriguez on 15/10/23.
//


import Foundation

struct MovieKeys {
    static let totalPages = "total_pages"
    static let results = "results"
    static let title = "title"
    static let overview = "overview"
    static let releaseDate = "release_date"
    static let posterPath = "poster_path"
}

struct Movie {
    let totalPages: Int
    let results: [MovieResult]
    
    struct MovieResult {
        let title: String
        let overview: String
        let releaseDate: String
        let posterPath: String
    }
    
    init?(data: [String: Any]) {
        guard let totalPages = data[MovieKeys.totalPages] as? Int,
              let resultsData = data[MovieKeys.results] as? [[String: Any]] else {
            return nil
        }
        
        self.totalPages = totalPages
        self.results = resultsData.compactMap { resultData in
            guard let title = resultData[MovieKeys.title] as? String,
                  let overview = resultData[MovieKeys.overview] as? String,
                  let releaseDate = resultData[MovieKeys.releaseDate] as? String,
                  let posterPath = resultData[MovieKeys.posterPath] as? String
            else {
                return nil
            }
            return MovieResult(title: title, overview: overview, releaseDate: releaseDate, posterPath: posterPath)
        }
    }
}
