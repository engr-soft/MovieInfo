//
//  MoviePlayerViewController.swift
//  MovieInfo
//
//  Created by Syed Hashmi on 4/29/19.
//  Copyright © 2019 24i. All rights reserved.
//

import UIKit
import YoutubePlayer_in_WKWebView
class MoviePlayerViewController: UIViewController {
    var videoKey:String?
    @IBOutlet var playerView: WKYTPlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let key = videoKey{
            playerView.load(withVideoId: key) //"Mc0TMWYTU_k"

        }
        else{
            self.dismiss(animated: true) {
                
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension MoviePlayerViewController:WKYTPlayerViewDelegate{
    func playerView(_ playerView: WKYTPlayerView, didChangeTo state: WKYTPlayerState) {
        
        if state == .ended{
            self.dismiss(animated: true) {
            }
        }
        
    }
    func playerViewDidBecomeReady(_ playerView: WKYTPlayerView) {
        playerView.playVideo()
    }
}
