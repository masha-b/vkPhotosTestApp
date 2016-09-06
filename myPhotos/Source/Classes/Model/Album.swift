//
//  Album.swift
//  myPhotos
//
//  Created by Мария on 31.08.16.
//  Copyright © 2016 Мария. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@objc(Album)
class Album:NSManagedObject{
    
    @NSManaged var id: NSNumber?
    @NSManaged var title: NSString
    @NSManaged var thumb: NSString
    @NSManaged var size: NSNumber?
    @NSManaged var photos: Set<Photo>?
    
    let thumbTypes:[String] = ["y", "x", "m"]
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
        self.title = "New Album"
        self.id = 0
    }
    
    func asSrtring() -> String{
        return "Album: [\(self.id)], title = \(self.title), size = \(self.size), thumb_src = \(self.thumb) className=\(self.dynamicType.description())"
    }
    
    func initWithDictionary(data:NSDictionary!)-> Album {
        self.setValue(data["id"], forKey: "id")
        self.setValue(data["size"], forKey: "size")
        self.setValue(data["title"], forKey: "title")
        
        var _photo:String = ""
        var _validPhotos = [String:NSDictionary]()
        if data["sizes"] != nil {
            for _size:NSDictionary in (data["sizes"] as! [NSDictionary]) {
                if thumbTypes.contains(_size["type"] as! String) {
                    _validPhotos[_size["type"] as! String] = _size
                }
            }
        }
        
        for thumbType:String in thumbTypes {
            if _validPhotos[thumbType] != nil {
                _photo = _validPhotos[thumbType]!["src"] as! String
                break
            }
        }
        
        self.setValue(_photo, forKey: "thumb")
        return self        
    }
    
    func updatePhotos(newPhotos:[Photo]) {
        self.deleteAllPhotos()
        for photo:Photo in newPhotos {
            self.mutableSetValueForKey("photos").addObject(photo)
        }
        self.save()
    }
    
    static func withDictionary(data:NSDictionary!)-> Album {
        return (NSEntityDescription.insertNewObjectForEntityForName("Album", inManagedObjectContext: AlbumController.instance.context) as! Album).initWithDictionary(data)
    }
    
    func save() {
        do {
            try self.managedObjectContext!.save()
        } catch {
            let saveError = error as NSError
            print(saveError)
        }
    }
    
    func deleteAllPhotos() {
        for photo:Photo in self.photos! {
            self.managedObjectContext!.deleteObject(photo)
        }
        
        do {
            try self.managedObjectContext!.save()
        } catch {
            let saveError = error as NSError
            print(saveError)
        }
    }
}
