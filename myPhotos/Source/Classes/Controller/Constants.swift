//
//  Constants.swift
//  myPhotos
//
//  Created by Мария on 30.08.16.
//  Copyright © 2016 Мария. All rights reserved.
//

import Foundation
import VK_ios_sdk

struct Constants {
    
    static let VK_APP_ID = "5610892"
    static let VK_SCOPE:[String] = [VK_PER_PHOTOS]
    
    static var isSimulator: Bool {
        return (TARGET_IPHONE_SIMULATOR != 0 ||  TARGET_OS_SIMULATOR != 0)
    }
    
}

enum MessageType {
    case Notification
    case Warning
    case Error
}
