//
//  MovieListVC.swift
//  SkeletonMovies
//
//  Created by Jesus Calleja Rodriguez on 13/10/23.
//

import UIKit

class MovieListVC: BaseVC {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var movieListStateLabel: UILabel!
    @IBOutlet weak var moviesTableView: UITableView!
    
    // MARK: - Public properties
    
    var viewModel: MovieListVM?
    
    // MARK: - Private properties
    
    private var movies: [MovieView] = []
    private var filteredMovies: [MovieView] = []
    private var isSearching: Bool = false
    private var searchBar: UISearchBar?
    private var refeshControl: UIRefreshControl?
    
    // MARK: - Life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel?.getMovies()
        self.initUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refeshControl = UIRefreshControl()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.resetSearch()
    }
    
    // MARK: - Private method
    
    private func initUI() {
        self.title = Localize().get("app_title")
        self.movieListStateLabel.isHidden = false
        self.moviesTableView.isHidden = true
        self.moviesTableView.addSubview(self.refeshControl ?? UIRefreshControl())
        self.refeshControl?.addTarget(self, action: #selector(self.refreshData), for: .valueChanged)
        self.configureSearchNavigationBar()
        self.updateState(show: true, message: Localize().get("movies_list_loading"))
    }
    
    private func configureSearchNavigationBar(){
        let rightSearchButton = UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        rightSearchButton.tintColor = UIColor.appSecondary
        rightSearchButton.setBackgroundImage(UIImage(named: Constants.Images.search), for: .normal)
        rightSearchButton.addTarget(self, action: #selector(self.setUpSearchBar), for: .touchUpInside)
        let rightSearchButtonItem = UIBarButtonItem(customView: rightSearchButton)
        self.navigationItem.rightBarButtonItem = rightSearchButtonItem
    }
    
    // MARK: - Actions
    
    private func resetSearch(){
        self.searchBar?.text = nil
        self.searchBar?.resignFirstResponder()
        self.filteredMovies = self.movies
        self.moviesTableView.reloadData()
    }
    
    private func onMovieSelected(movie: MovieView) {
        self.viewModel?.onMovieSelected(movie: movie)
    }
    
    private func updateState(show: Bool, message: String) {
        self.movieListStateLabel.text = message
        self.movieListStateLabel.isHidden = !show
        self.moviesTableView.isHidden = show
        self.refeshControl?.endRefreshing()
    }
    
    @objc private func setUpSearchBar(){
        self.searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 400, height: 15))
        self.searchBar?.delegate = self
        self.searchBar?.placeholder = NSLocalizedString("search_movies", comment: "")
        let searchBarItem = UIBarButtonItem(customView: self.searchBar ?? UISearchBar())
        self.navigationItem.rightBarButtonItem = searchBarItem
    }
    
    @objc func refreshData() {
        self.viewModel?.getMovies()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MovieListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = self.filteredMovies[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIds.movie) as? MovieTableViewCell
        cell?.bindData(movie: movie)
        cell?.loadAsyncImageData(imagePosterUrl: movie.imagePosterUrl) { imageData in
            if let imageData = imageData {
                DispatchQueue.main.async {
                    if indexPath.row < self.filteredMovies.count {
                        cell?.posterImageView.image = UIImage(data: imageData)
                        self.filteredMovies[indexPath.row].imagePosterData = imageData
                    }
                }
                
            }
        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.onMovieSelected(movie: self.filteredMovies[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //MARK: Avoid pagination when searching
        
        if self.isSearching {
            return
        }
        
        //MARK: Pagination
        
        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 5
        if indexPath.row == lastRowIndex {
            self.viewModel?.getMoreMovies()
        }
    }
}

// MARK: - SearchBarDelegate

extension MovieListVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.isSearching = searchText.isEmpty ? false : true
        if searchText.isEmpty {
            self.filteredMovies = self.movies
        } else {
            self.viewModel?.onMovieSearch(title: searchText)
            self.filteredMovies = self.movies.filter { movie in
                return movie.title.lowercased().contains(searchText.lowercased())
            }
        }
        self.moviesTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        self.filteredMovies = movies
        self.moviesTableView.reloadData()
        searchBar.resignFirstResponder()
    }
}

// MARK: - MovieListVMOutput

extension MovieListVC: MovieListVMOutput {
    
    func updateViewProgress(show: Bool) {
        self.updateProgressSpinner(visible: show)
    }
    
    func updateViewState(show: Bool, message: String) {
        self.updateState(show: show, message: message)
    }
    
    func showMovies(moviesList: [MovieView], filtered: Bool)  {
        if self.movies.isEmpty {
            self.movies = moviesList
        } else {
            self.movies.append(contentsOf: moviesList)
        }
        self.filteredMovies = filtered ? moviesList : self.movies
        self.moviesTableView.reloadData()
        self.moviesTableView.isHidden = false
        self.movieListStateLabel.isHidden = true
        self.refeshControl?.endRefreshing()
    }
    
}
