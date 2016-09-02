//
//  Photo.swift
//  myPhotos
//
//  Created by Мария on 01.09.16.
//  Copyright © 2016 Мария. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@objc(Photo)
class Photo:NSManagedObject{
    
    @NSManaged var id: NSNumber?
    @NSManaged var albumId: NSNumber?
    @NSManaged var date: NSNumber?
    @NSManaged var photo: NSString
    @NSManaged var thumb: NSString
    @NSManaged var text: NSString
    
    let potoTypes:[String] = ["photo_2560", "photo_1280", "photo_807", "photo_604", "photo_130", "photo_75"]
    let thumbTypes:[String] = ["photo_604", "photo_130", "photo_75"]
    
    /*override func awakeFromInsert() {
        super.awakeFromInsert()
        self.id = 0
    }*/
    
    func asSrtring() -> String{
        return "Photo: [\(self.id)], thumb = \(self.thumb), photo = \(self.photo), date = \(self.date), text = \(self.text) className=\(self.dynamicType.description())"
    }
    
    func initWithDictionary(data:NSDictionary!)-> Photo {
        self.setValue(data["id"], forKey: "id")
        self.setValue(data["album_id"], forKey: "albumId")
        self.setValue(data["date"], forKey: "date")
        self.setValue(data["text"], forKey: "text")
        
        var _photo:String = ""
        for photoType:String in potoTypes {
            if data[photoType] != nil {
                _photo = data[photoType] as! String
                break
            }
        }
        self.setValue(_photo, forKey: "photo")
        
        var _thumb:String = ""
        for thumbType:String in thumbTypes {
            if data[thumbType] != nil {
                _thumb = data[thumbType] as! String
                break
            }
        }
        self.setValue(_thumb, forKey: "thumb")
        
        return self
    }
    
    static func withDictionary(data:NSDictionary!)-> Photo {
        let context:NSManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        return (NSEntityDescription.insertNewObjectForEntityForName("Photo", inManagedObjectContext: context) as! Photo).initWithDictionary(data)
    }
    
    func save() {
        do {
            try self.managedObjectContext!.save()
        } catch {
            let saveError = error as NSError
            print(saveError)
        }
    }
}
