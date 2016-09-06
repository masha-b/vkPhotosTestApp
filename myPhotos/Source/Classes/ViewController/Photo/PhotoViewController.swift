//
//  PhotoViewController.swift
//  myPhotos
//
//  Created by Мария on 01.09.16.
//  Copyright © 2016 Мария. All rights reserved.
//

import UIKit
import VK_ios_sdk
import CoreData
import SKPhotoBrowser
import SDWebImage
import PureLayout

class PhotoViewController:VkViewController, UICollectionViewDelegate, UICollectionViewDataSource, SKPhotoBrowserDelegate {
    
    let layout: UICollectionViewFlowLayout! = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .Vertical
        return layout
    }()
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.whiteColor()
        refreshControl.addTarget(self, action: #selector(PhotoViewController.vkLoad), forControlEvents: UIControlEvents.ValueChanged)
        return refreshControl
    }()
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView.init(frame: CGRectZero, collectionViewLayout: self.layout)
        view.dataSource = self
        view.delegate = self
        view.contentMode = .ScaleToFill
        view.backgroundColor = .clearColor()
        view.bounces = true
        view.alwaysBounceVertical = true
        view.showsVerticalScrollIndicator = false
        view.configureForAutoLayout()
        view.addSubview(self.refreshControl)
        view.registerClass(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        view.registerClass(EmptyCollectionViewCell.self, forCellWithReuseIdentifier: "emptyCell")
        
        return view
    }()
    
    var album:Album!
    var didSetupConstraints = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = album.title as String
        
        self.makeItems()
        
        self.setData()
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(rgba: "#666666")
        view.addSubview(collectionView)
        view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        if (!didSetupConstraints) {
            collectionView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 10, left: 10.0, bottom: 10.0, right: 10.0))            
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
    
    func makeItems(){
        if album.photos!.count == 0 {
            self.refreshControl.beginRefreshing()
            self.vkLoad()
        }
    }
    
    override func setData() {
        self.collectionView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    override func loadData(){
        PhotoController.instance.loadFromApi(album).executeWithResultBlock({ (response) -> Void in
            
            let data =  response.json as! NSDictionary
            var _photos = [Photo]()
            
            for vkPhoto:NSDictionary in data["items"] as! [NSDictionary] {
                _photos.append(Photo.withDictionary(vkPhoto))
            }
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                self.album.updatePhotos(_photos)
                dispatch_async(dispatch_get_main_queue(), {
                    self.setData()
                });
            });
            
            }, errorBlock: {
                (error) -> Void in
                self.showMessage(MessageType.Error, title: nil, subTitle: error.localizedDescription)
                self.setData()
        })
    }
    
    
    // MARK: - UICollectionViewDelegate, UICollectionViewDataSource
    
    func collectionView(collectionView : UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize {
        let kPadding:CGFloat = 10
        if self.album.photos!.count > 0 {
            let kSize =  (UIScreen.mainScreen().bounds.width - kPadding*3)/2
            return CGSizeMake(kSize, kSize)
        }
        return CGSizeMake((UIScreen.mainScreen().bounds.width - kPadding*2), (self.view.frame.size.height - (self.navigationController?.tabBarController?.tabBar.frame.size.height)! - self.navigationController!.navigationBar.frame.size.height)-kPadding*2)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.album.photos!.count > 0 ? self.album.photos!.count : 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if self.album.photos!.count > 0 {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! PhotoCollectionViewCell
            cell.photo = album.photos![album.photos!.startIndex.advancedBy(indexPath.row)]
            return cell
        }
        return collectionView.dequeueReusableCellWithReuseIdentifier("emptyCell", forIndexPath: indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let browser = SKPhotoBrowser(photos: createWebPhotos(album))
        browser.initializePageIndex(indexPath.row)
        browser.delegate = self
        presentViewController(browser, animated: true, completion: nil)
    }
    
}


extension PhotoViewController {
    func didDismissAtPageIndex(index: Int) {}
    
    func didDismissActionSheetWithButtonIndex(buttonIndex: Int, photoIndex: Int) {}
    
    func removePhoto(browser: SKPhotoBrowser, index: Int, reload: (() -> Void)) {
        let key:String = "vkPhoto" + String((album.photos![album.photos!.startIndex.advancedBy(index)]).id)
        SKCache.sharedCache.removeImageForKey(key)
        reload()
    }
}

// MARK: - private

private extension PhotoViewController {
    func createWebPhotos(album:Album) -> [SKPhotoProtocol] {
        return (0..<(album.photos?.count)!).map { (i: Int) -> SKPhotoProtocol in
            let photo = SKPhoto.photoWithImageURL((album.photos![album.photos!.startIndex.advancedBy(i)]).photo as String)
            photo.caption = (album.photos![album.photos!.startIndex.advancedBy(i)]).text as String
            photo.shouldCachePhotoURLImage = true
            return photo
        }
    }
}
