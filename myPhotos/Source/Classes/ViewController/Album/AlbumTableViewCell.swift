//
//  AlbumTableViewCell.swift
//  myPhotos
//
//  Created by Мария on 31.08.16.
//  Copyright © 2016 Мария. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class AlbumTableViewCell: UITableViewCell {
    
    @IBOutlet var imageViewIcon: UIImageView!
    @IBOutlet var labelTitle: UILabel!
    @IBOutlet var labelCreated: UILabel!
    @IBOutlet var labelSize: UILabel!
    @IBOutlet var buttonFavorite: UIButton!
    @IBOutlet var activityIndicator:UIActivityIndicatorView!
    
    var album:Album! {
        didSet {
            self.activityIndicator.hidden = false
            self.activityIndicator.startAnimating()
            self.labelTitle.text = self.album.title as String
            
            if self.album.thumb.length > 0 {
                let downloader:SDWebImageDownloader = SDWebImageDownloader.sharedDownloader()
                downloader.downloadImageWithURL(NSURL(string: self.album.thumb as String), options: SDWebImageDownloaderOptions.UseNSURLCache, progress: { (receivedSize, expectedSize) in
                    
                    }, completed: { (image, data, error, finished) in
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.activityIndicator.stopAnimating()
                            if image != nil && finished {
                                self.imageViewIcon.image = image
                            }
                            else {
                                self.imageViewIcon.image = UIImage(named: "icon_nophoto")!
                            }
                        })
                })
            }
            else {
                self.activityIndicator.stopAnimating()
                imageViewIcon.image = UIImage(named: "icon_no_album")!
            }
        }
    }
    
}