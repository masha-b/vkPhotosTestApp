//
//  AlbumTableViewCell.swift
//  myPhotos
//
//  Created by Мария on 31.08.16.
//  Copyright © 2016 Мария. All rights reserved.
//

import Foundation
import UIKit
import CoreData

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
                imageViewIcon.imageFromURL(self.album.thumb as String, placeholder: UIImage(named: "icon_nophoto")!, fadeIn: true) {
                    (image: UIImage?) in
                    if image != nil {
                        self.imageViewIcon.image = image!.resize(CGSize(width: self.imageViewIcon.frame.size.width*2, height: self.imageViewIcon.frame.size.height*2))
                        self.activityIndicator.hidden = true
                    }
                }
            }
            else {
                self.activityIndicator.hidden = true
                imageViewIcon.image = UIImage(named: "icon_nophoto")!
            }
        }
    }
    
}