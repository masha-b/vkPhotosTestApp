//
//  emptyCollectionView.swift
//  myPhotos
//
//  Created by Мария on 06.09.16.
//  Copyright © 2016 Мария. All rights reserved.
//

import Foundation
import UIKit

class EmptyCollectionViewCell: UICollectionViewCell {
    
    lazy var labelText: UILabel = {
        let label = UILabel.newAutoLayoutView()
        label.font = UIFont.systemFontOfSize(15)
        label.textColor = .whiteColor()
        label.textAlignment = .Center
        label.lineBreakMode = .ByWordWrapping
        label.numberOfLines = 0
        label.text = "Нет данных"
        return label
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
        
        self.contentView.addSubview(labelText)
        self.setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if (!didSetupConstraints) {
            labelText.autoSetDimension(.Width, toSize: 200)
            labelText.autoSetDimension(.Height, toSize: 20)
            labelText.autoAlignAxis(.Horizontal, toSameAxisOfView: self.contentView)
            labelText.autoAlignAxis(.Vertical, toSameAxisOfView: self.contentView)
            
            didSetupConstraints = true
            super.setNeedsLayout()
        }
    }
}
