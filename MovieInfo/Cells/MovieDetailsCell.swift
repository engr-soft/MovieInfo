//
//  MovieCell.swift
//  MovieInfo
//
//  Created by Syed Hashmi on 4/29/19.
//  Copyright © 2019 24i All rights reserved.
//

import UIKit
import Kingfisher
import SafariServices
class MovieDetailsCell: UITableViewCell {
    var viewModel:MovieDetailCellViewViewModel?
    @IBOutlet weak var watchTrailerButton: UIButton!
    @IBAction func watchTrailerButtonAction(_ sender: Any) {
        guard let viewModel = viewModel, let url = viewModel.trailerURL else {
            return
        }
    
       
        
//        let playerVC:UIViewController = UIStoryboard(name: StoryBoardConstants.MainStoryBoard.rawValue, bundle: nil).instantiateViewController(withIdentifier: "MoviePlayerViewController") as! MoviePlayerViewController
//     viewModel.trailerURL
        
        
        if let topVC = UIApplication.getTopMostViewController() {
                let svc = SFSafariViewController(url: url)
                topVC.present(svc, animated: true, completion: nil)
        }
        
    }
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var genresHeaderLabel: UILabel!
    @IBOutlet weak var genresDetailsLabel: UILabel!
    @IBOutlet weak var dateHeaderLabel: UILabel!
    @IBOutlet weak var dateDetailsLabel: UILabel!
    @IBOutlet weak var overviewHeaderLabel: UILabel!
    @IBOutlet weak var overviewDetailsLabel: UILabel!
    
    
    func configure(viewModel: MovieDetailCellViewViewModel) {
        self.viewModel = viewModel
        ratingLabel.text = viewModel.rating
        genresHeaderLabel.text = "Genres"
        genresDetailsLabel.text = viewModel.genres
        
        genresHeaderLabel.text = "Genres"
        genresDetailsLabel.text = viewModel.genres
    
        dateHeaderLabel.text = "Date"
        dateDetailsLabel.text = viewModel.releaseDate
        
        overviewHeaderLabel.text = "Overview"
        overviewDetailsLabel.text = viewModel.overview
        
    }
    
}
