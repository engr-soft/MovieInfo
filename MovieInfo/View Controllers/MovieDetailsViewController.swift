//
//  MovieDetailsViewController.swift
//  StretchHeaderDemo
//
//  Created by yamaguchi on 2016/03/27.
//  Copyright © 2016年 h.yamaguchi. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import StretchHeader


class MovieDetailsViewController: UIViewController {
    let disposeBag = DisposeBag()
    var header : StretchHeader!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var infoLabel: UILabel!
    var titleLabel:UILabel!
    var movieDetailCellViewViewModel: MovieDetailCellViewViewModel?
    
    
    
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(UINib(nibName: "MovieDetailsCell", bundle: nil), forCellReuseIdentifier: "MovieDetailsCell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        setupHeaderView()
        fetchUIDataFromService()
        
        if let movieDetailCellViewViewModel = movieDetailCellViewViewModel{
            
            movieDetailCellViewViewModel.shouldOpenTrailerWithVideoKey.drive(onNext: {[unowned self] (videoKey) in
                if let key = videoKey {
                    self.performSegue(withIdentifier: StoryBoardConstants.segueShowPlayer.rawValue, sender: key)
                }
                
            }).disposed(by: disposeBag)
        }
        
    }
    
    
    func setupHeaderView() {
        let options = StretchHeaderOptions()
        options.position = .fullScreenTop
        
        header = StretchHeader()
        header.stretchHeaderSize(headerSize: CGSize(width: view.frame.size.width, height: 220),
                                 imageSize: CGSize(width: view.frame.size.width, height: 220),
                                 controller: self,
                                 options: options)
        
        
        
        
        // custom
        titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 10, y: header.frame.size.height - 70, width: header.frame.size.width - 20, height: 60)
        titleLabel.textColor = UIColor.black
        titleLabel.layer.cornerRadius = 30
        titleLabel.layer.borderColor = UIColor.yellow.cgColor
        titleLabel.layer.borderWidth = 1.0
        titleLabel.layer.masksToBounds = true
        titleLabel.text = ""
        titleLabel.backgroundColor = UIColor.lightGray
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        header.addSubview(titleLabel)
        if let movieDetailCellViewViewModel = movieDetailCellViewViewModel{
            header.imageView.kf.setImage(with: movieDetailCellViewViewModel.posterURL)
            titleLabel.text = "   \(movieDetailCellViewViewModel.title)   "
            titleLabel.sizeToFit()
            titleLabel.frame = CGRect(x: titleLabel.frame.origin.x, y: titleLabel.frame.origin.y, width: titleLabel.frame.size.width, height: 60)
        }
        tableView.tableHeaderView = header
    }
    
    private func fetchUIDataFromService(){
        guard let movieDetailCellViewViewModel = movieDetailCellViewViewModel else {
            return
        }
        movieDetailCellViewViewModel.fetchMovieDetails()
        movieDetailCellViewViewModel.movie.drive(onNext: {[unowned self] (_) in
            self.header.imageView.kf.setImage(with: movieDetailCellViewViewModel.posterURL)
            self.titleLabel.text = "   \(movieDetailCellViewViewModel.title)   "
            self.titleLabel.sizeToFit()
            self.titleLabel.frame = CGRect(x: self.titleLabel.frame.origin.x, y: self.titleLabel.frame.origin.y, width: self.titleLabel.frame.size.width, height: 60)
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        movieDetailCellViewViewModel.isFetching.drive(activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        movieDetailCellViewViewModel.error.drive(onNext: {[unowned self] (error) in
            self.infoLabel.isHidden = !movieDetailCellViewViewModel.hasError
            self.infoLabel.text = error
        }).disposed(by: disposeBag)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueID = segue.identifier, segueID == StoryBoardConstants.segueShowPlayer.rawValue{
            if let vc = segue.destination as? MoviePlayerViewController{
                if let sender = sender, let videoKey = sender as? String{
                    
                        vc.videoKey = videoKey
                    }
                
            }
        }
    }
}

extension MovieDetailsViewController:UITableViewDelegate,UITableViewDataSource{
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieDetailsCell", for: indexPath) as! MovieDetailsCell
        if let viewModel = movieDetailCellViewViewModel {
            cell.configure(viewModel: viewModel)
        }
        return cell
    }
}
extension MovieDetailsViewController:UIScrollViewDelegate{
    // MARK: - ScrollView Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        header.updateScrollViewOffset(scrollView)
    }
    
    
}
