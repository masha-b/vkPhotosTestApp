//
//  PhotoController.swift
//  myPhotos
//
//  Created by Мария on 01.09.16.
//  Copyright © 2016 Мария. All rights reserved.
//

import Foundation
import VK_ios_sdk

class PhotoController {
    
    static let instance = PhotoController()
    
    func loadFromApi(album:Album)-> VKRequest {
        return VKApi.requestWithMethod("photos.get", andParameters:[VK_API_OWNER_ID:VKSdk.accessToken().userId, "album_id":album.id!])
    }
}
