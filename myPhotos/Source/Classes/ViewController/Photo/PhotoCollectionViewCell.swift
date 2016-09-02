//
//  PhotoCollectionCell.swift
//  myPhotos
//
//  Created by Мария on 02.09.16.
//  Copyright © 2016 Мария. All rights reserved.
//

import Foundation
import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageViewIcon: UIImageView!
    @IBOutlet var labelText: UILabel!
    @IBOutlet var viewText: UIView!
    @IBOutlet var activityIndicator:UIActivityIndicatorView!
    
    var photo:Photo! {
        didSet {
            self.activityIndicator.hidden = false
            self.activityIndicator.startAnimating()
            self.viewText.hidden = true
            
            self.labelText.text = self.photo.text as String
            if self.photo.thumb.length > 0 {
                imageViewIcon.imageFromURL(self.photo.thumb as String, placeholder: UIImage(named: "icon_nophoto_big")!, fadeIn: true) {
                    (image: UIImage?) in
                    if image != nil {
                        self.imageViewIcon.image = image!.resize(CGSize(width: self.imageViewIcon.frame.size.width*2, height: self.imageViewIcon.frame.size.height*2))
                        self.activityIndicator.hidden = true
                        self.viewText.hidden = false
                    }
                }
                
            }
            else {
                self.activityIndicator.hidden = true
                imageViewIcon.image = UIImage(named: "icon_nophoto_big")!
                self.viewText.hidden = false
            }
        }
    }
}