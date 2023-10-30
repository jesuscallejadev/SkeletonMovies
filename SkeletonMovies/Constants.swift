//
//  Constants.swift
//  SkeletonMovies
//
//  Created by Jesus Calleja Rodriguez on 12/10/23.
//

class Constants {
    
    struct StoryBoardIds {
        static let splash = "Splash"
        static let onboarding = "Onboarding"
        static let moviesList = "MoviesList"
        static let movieDetail = "MovieDetail"
    }
    
    struct ViewControllerIds {
        static let splashVC = "SplashVC"
        static let pageVC = "PageVC"
        static let onboardingVC = "OnboardingVC"
        static let moviesListVC = "MovieListVC"
        static let movieDetailVC = "MovieDetailVC"
    }
    
    struct OnboardingIds {
        static let onboardingFlag = "OnboardingFlag"
        static let onboardingIdFirst = "OnboardingIdFirst"
        static let onboardingIdSecond = "OnboardingIdSecond"
        static let onboardingIdThird = "OnboardingIdThird"
    }
    
    struct AnimationsIds {
        static let animationFirst =
            "movies"
        static let animationSecond = "search"
        static let animationThird = "movieDetails"
    }
    
    struct CellIds {
        static let movie = "MovieCellId"
    }
    
    struct API {
        static let token = "token"
        static let userTokenValue = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3MzIwYjA0NTkxZTQ0ZGNlMzFmOGMwNGU0MjFlOThlZiIsInN1YiI6IjY1Mjc5MzQ2MGNiMzM1MTZmNWM3ZjZhZiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.AEamipwiaDFofreQBFj7yKhNfGkaezhUjSBFtDDczNU"
        static let moviesBaseUrl = "https://api.themoviedb.org/3/"
        static let imagesBaseUrl = "https://image.tmdb.org/t/p/original/"
        static let getMoviesEndpoint = "discover/movie"
        static let searchMoviesEndpoint = "search/movie"
        static let page = "page"
        static let query = "query"
        static let startPage = 1
        static let endPage = 500
    }
    
    struct Images {
        static let search = "search"
        static let moviePlaceholder = "moviePlaceholder"
    }
    
}
