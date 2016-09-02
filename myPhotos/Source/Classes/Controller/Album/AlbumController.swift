//
//  AlbumController.swift
//  myPhotos
//
//  Created by Мария on 01.09.16.
//  Copyright © 2016 Мария. All rights reserved.
//

import Foundation
import VK_ios_sdk
import CoreData

class AlbumController {
    
    var vkLoadAlbumParametrs:[NSObject : AnyObject] = ["need_system":"1", "need_covers":"1", "photo_sizes":"1"]
    var albums:[Album]!
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let request = NSFetchRequest(entityName:"Album")
    
    static let instance = AlbumController()
    
    private init() {
        initAlbums()
    }
    
    func loadFromApi()-> VKRequest {
        print(VKSdk.accessToken().userId)
        vkLoadAlbumParametrs[VK_API_OWNER_ID] = VKSdk.accessToken().userId
        return VKApi.requestWithMethod("photos.getAlbums", andParameters:vkLoadAlbumParametrs)
    }
    
    func updateAlbums(albumList:[Album]) {
        self.deleteAlbums()
        for album:Album in albumList {
            album.save()
            self.albums.append(album)
        }
    }
    
    func initAlbums() {
        do {
            self.albums = try context.executeFetchRequest(request) as! [Album]
        } catch let error as NSError {
            print("Fetch failed: \(error.localizedDescription)")
        }
    }
    
    func deleteAlbums() {
        for album:Album in self.albums {
            context.deleteObject(album as NSManagedObject)
        }
        self.albums = [Album]()
        do {
            try context.save()
        } catch let error as NSError {
            print("Fetch failed: \(error.localizedDescription)")
        }
    }
    
    
}
