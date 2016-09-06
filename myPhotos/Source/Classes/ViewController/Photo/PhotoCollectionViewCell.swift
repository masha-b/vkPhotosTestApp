//
//  PhotoCollectionCell.swift
//  myPhotos
//
//  Created by Мария on 02.09.16.
//  Copyright © 2016 Мария. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class PhotoCollectionViewCell: UICollectionViewCell {
    
    lazy var imageViewIcon: UIImageView = {
        let view = UIImageView.newAutoLayoutView()
        view.backgroundColor = .clearColor()
        view.contentMode = .ScaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    lazy var labelText: UILabel = {
        let label = UILabel.newAutoLayoutView()
        label.font = UIFont(name: "System", size: 15)
        label.textColor = UIColor(rgba: "#4C4C4C")
        label.textAlignment = .Left
        label.lineBreakMode = .ByWordWrapping
        label.numberOfLines = 0
        return label
    }()
    lazy var viewText: UIView = {
        let view = UIView.newAutoLayoutView()
        view.backgroundColor = UIColor(rgba: "#ffffff").colorWithAlphaComponent(0.6)
        return view
    }()
    lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView.newAutoLayoutView()
        view.activityIndicatorViewStyle = .Gray
        view.hidesWhenStopped = true
        return view
    }()
    
    var didSetupConstraints = false
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        self.initViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initViews()
    }
    
    
    func initViews() {        
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = UIColor(rgba: "#CCCCCC").CGColor
        
        self.contentView.addSubview(imageViewIcon)
        self.contentView.addSubview(activityIndicator)
        self.contentView.addSubview(viewText)
        viewText.addSubview(labelText)
        
        self.setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if (!didSetupConstraints) {
            imageViewIcon.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 0, left: 0.0, bottom: 0.0, right: 0.0))
            
            activityIndicator.autoSetDimension(.Width, toSize: 20)
            activityIndicator.autoSetDimension(.Height, toSize: 20)
            activityIndicator.autoAlignAxis(.Horizontal, toSameAxisOfView: self.contentView)
            activityIndicator.autoAlignAxis(.Vertical, toSameAxisOfView: self.contentView)
            
            viewText.autoSetDimension(.Height, toSize: 31, relation: .GreaterThanOrEqual)
            viewText.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: imageViewIcon, withOffset: 0)
            viewText.autoPinEdge(.Left, toEdge: .Left, ofView: imageViewIcon, withOffset: 0)
            viewText.autoPinEdge(.Right, toEdge: .Right, ofView: imageViewIcon, withOffset: 0)
            
            labelText.autoSetDimension(.Height, toSize: 0, relation: .GreaterThanOrEqual)
            labelText.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0))
            
            didSetupConstraints = true
            super.setNeedsLayout()
        }
    }
    
    
    var photo:Photo! {
        didSet {
            
            self.activityIndicator.hidden = false
            self.activityIndicator.startAnimating()
            self.labelText.text = self.photo.text as String
            self.viewText.hidden = self.photo.text.length == 0
            
            if self.photo.thumb.length > 0 {
                let downloader:SDWebImageDownloader = SDWebImageDownloader.sharedDownloader()
                downloader.downloadImageWithURL(NSURL(string: self.photo.thumb as String), options: SDWebImageDownloaderOptions.UseNSURLCache, progress: { (receivedSize, expectedSize) in
                    
                    }, completed: { (image, data, error, finished) in
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.activityIndicator.stopAnimating()
                            if image != nil && finished {
                                self.imageViewIcon.image = image.resize(CGSizeMake(self.imageViewIcon.frame.size.width*2, self.imageViewIcon.frame.size.height*2))
                            }
                            else {
                                self.imageViewIcon.image = UIImage(named: "icon_no_photo")!
                            }
                        })
                })
            }
            else {
                self.activityIndicator.stopAnimating()
                imageViewIcon.image = UIImage(named: "icon_no_photo")!
            }
        }
    }
}