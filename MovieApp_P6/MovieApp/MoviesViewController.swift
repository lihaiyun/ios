//
//  MoviesViewController.swift
//  MovieApp
//
//  Created by Haiyun on 7/3/22.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource {
    // Declare an array of Movie objects
    var movieList : [Movie] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : MovieTableViewCell = tableView.dequeueReusableCell (withIdentifier: "MovieCell", for: indexPath) as! MovieTableViewCell
        let m = movieList[indexPath.row]
        
        // Name
        cell.nameLabel.text = m.name
        
        // Rating
        var rating = ""
        for _ in 1...m.rating {
            rating.append("🍿")
        }
        cell.ratingLabel.text = rating
        
        // Image
        let url = URL(string: m.image)!
        DispatchQueue.global().async {
            // Fetch Image Data
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    // Create Image and Update Image View
                    cell.movieImageView.image = UIImage(data: data)
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let movie = movieList[indexPath.row]
            DataManager.deleteMovie(id: movie.id)
            loadMovies()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add test data
        DataManager.addTestData()
        
        // Do any additional setup after loading the view.
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMovies()
    }
    
    func loadMovies() {
        movieList = DataManager.getMovieList()
        movieList.sort{$0.name < $1.name}
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Hide Tab Bar when push
        segue.destination.hidesBottomBarWhenPushed = true
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "ShowMovieDetails")
        {
            let detailsViewController = segue.destination as! MovieDetailsViewController
            if let path = tableView.indexPathForSelectedRow {
                let movie = movieList[path.row]
                detailsViewController.movie = movie
            }
        }
        
        // Here we check for the AddMovie segue,
        // which is trigger by the user clicking on the +
        // button at the top of the navigation bar
        //
        if(segue.identifier == "AddMovie")
        {
            let saveMovieViewController = segue.destination as! SaveMovieViewController
            let movie = Movie(id: "", name: "", desc: "", rating: 0, image: "https://raw.githubusercontent.com/lihaiyun/ios/main/resources/popcorn.png")
            saveMovieViewController.movie = movie
        }
    }
}
