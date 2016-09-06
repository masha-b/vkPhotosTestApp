//
//  AlbumViewController.swift
//  myPhotos
//
//  Created by Мария on 01.09.16.
//  Copyright © 2016 Мария. All rights reserved.
//

import UIKit
import VK_ios_sdk
import CoreData

class AlbumViewController:VkViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var albums = [Album]()
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Альбомы"
        self.makeRefreshControl()
        self.makeItems()
    }
    
    // MARK: - Make
    
    func makeRefreshControl() {
        refreshControl.tintColor = UIColor.whiteColor()
        refreshControl.addTarget(self, action: #selector(vkLoad), forControlEvents: .ValueChanged)
        tableView!.addSubview(refreshControl)
    }
    
    func makeItems(){
        tableView.estimatedRowHeight = 90.0;
        tableView.rowHeight = UITableViewAutomaticDimension;
        albums = AlbumController.instance.albums
        if albums.count == 0 {
            self.refreshControl.beginRefreshing()
            self.vkLoad()
        }
    }
    
    override func setData() {
        tableView.allowsSelection = albums.count > 0
        self.refreshControl.endRefreshing()
        self.tableView.reloadData()
    }
    
    override func loadData(){
        AlbumController.instance.loadFromApi().executeWithResultBlock({ (response) -> Void in
            
            let data =  response.json as! NSDictionary
            var _albums = [Album]()
                
                for vkAlbum:NSDictionary in data["items"] as! [NSDictionary] {
                    _albums.append(Album.withDictionary(vkAlbum))
                }
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                AlbumController.instance.updateAlbums(_albums)
                dispatch_async(dispatch_get_main_queue(), {
                    self.albums = AlbumController.instance.albums
                    self.setData()
                    });
                });
                
            }, errorBlock: {
                (error) -> Void in
                self.showMessage(MessageType.Error, title: nil, subTitle: error.localizedDescription)
                self.setData()
                print(error)
        })
    }
    
    // MARK: - UITableView DetaSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count > 0 ? albums.count : 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return albums.count > 0 ? UITableViewAutomaticDimension : self.view.frame.size.height - (self.navigationController?.tabBarController?.tabBar.frame.size.height)! - self.navigationController!.navigationBar.frame.size.height
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = albums.count > 0 ? "albumTableViewCell" : "emptyTableViewCell"
        
        if albums.count > 0 {
            var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! AlbumTableViewCell!
            if cell == nil {
                tableView.registerClass(AlbumTableViewCell.classForCoder(), forCellReuseIdentifier: cellIdentifier)
                cell = AlbumTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
                
            }
            cell.selectionStyle = .None
            cell.album = albums[indexPath.row]
            return cell
        }
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
            
        }
        cell!.selectionStyle = .None
        return cell!
    }
    
    // MARK: - UITableView Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let viewController:PhotoViewController = PhotoViewController()
        viewController.album = albums[indexPath.row]
        self.navigationController?.pushViewController(viewController, animated: true)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
