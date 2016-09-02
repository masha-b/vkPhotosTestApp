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

class PhotoViewController:VkViewController, UICollectionViewDelegate, UICollectionViewDataSource, SKPhotoBrowserDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var album:Album!
    var images = [SKPhotoProtocol]()
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = album.title as String
        self.makeRefreshControl()
        self.makeItems()
    }
    
    func makeRefreshControl() {
        refreshControl.tintColor = UIColor.whiteColor()
        refreshControl.addTarget(self, action: #selector(vkLoad), forControlEvents: .ValueChanged)
        collectionView!.addSubview(refreshControl)
    }
    
    func makeItems(){
        if album.photos!.count == 0 {
            self.refreshControl.beginRefreshing()
            self.vkLoad()
        }
    }
    
    override func setData() {
        self.refreshControl.endRefreshing()
        self.collectionView.reloadData()
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
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("photoCollectionViewCell", forIndexPath: indexPath) as! PhotoCollectionViewCell
            cell.photo = album.photos![album.photos!.startIndex.advancedBy(indexPath.row)]
            return cell
        }
        return collectionView.dequeueReusableCellWithReuseIdentifier("emptyCollectionViewCell", forIndexPath: indexPath)
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
