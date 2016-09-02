//
//  ViewController.swift
//  myPhotos
//
//  Created by Мария on 03.09.16.
//  Copyright © 2016 Мария. All rights reserved.
//

import Foundation
import CRToast
import UIColor_Hex_Swift

class ViewController: UIViewController {
    
    func showMessage(messageType: MessageType, title: String?, subTitle: String?) -> Void {
        showMessage(messageType, title: title, subTitle: subTitle, duration: 2.5, identifierKey: nil, completionBlock: nil)
    }
    
    func showMessage(messageType: MessageType, title: String?, subTitle: String?, duration: CGFloat, identifierKey: String?, completionBlock: (() -> Void)?) -> Void {
        
        var backgroundColor :UIColor;
        
        switch messageType {
        case .Notification:
            backgroundColor = UIColor(rgba: "#1ecb5f").colorWithAlphaComponent(0.7)
        case .Warning:
            backgroundColor = UIColor(rgba: "#a47739").colorWithAlphaComponent(0.7)
            
        case .Error:
            backgroundColor = UIColor(rgba: "#e9671d").colorWithAlphaComponent(0.7)
            
        }
        var _title:String = ""
        if title == nil || NSString(string: title!).length == 0 {
            _title = "Внимание"
        }
        
        if subTitle == nil {
            _title = ""
        }
        
        var _identifierKey:String = ""
        if identifierKey == nil {
            _identifierKey = "otherIdentifierKey"
        }
        
        let options = [
            kCRToastTextKey: _title,
            kCRToastTextColorKey: UIColor.whiteColor(),
            kCRToastFontKey: UIFont(name: "HelveticaNeue", size: 14.0)!,
            kCRToastTextAlignmentKey: NSTextAlignment.Center.rawValue,
            kCRToastTextMaxNumberOfLinesKey: NSNumber(integer: 2),
            kCRToastSubtitleTextKey: subTitle!,
            kCRToastSubtitleFontKey: UIFont(name: "HelveticaNeue-Light", size: 14.0)!,
            kCRToastSubtitleTextAlignmentKey: NSTextAlignment.Center.rawValue,
            kCRToastSubtitleTextMaxNumberOfLinesKey: NSNumber(integer: 2),
            kCRToastBackgroundColorKey : backgroundColor,
            kCRToastAnimationInTypeKey : CRToastAnimationType.Linear.rawValue,
            kCRToastAnimationOutTypeKey : CRToastAnimationType.Linear.rawValue,
            kCRToastAnimationInDirectionKey : CRToastAnimationDirection.Top.rawValue,
            kCRToastAnimationOutDirectionKey : CRToastAnimationDirection.Top.rawValue,
            kCRToastTimeIntervalKey: duration,
            kCRToastNotificationTypeKey : CRToastType.NavigationBar.rawValue,
            kCRToastNotificationPresentationTypeKey : CRToastPresentationType.Cover.rawValue,
            kCRToastUnderStatusBarKey : NSNumber(bool: false),
            kCRToastIdentifierKey : _identifierKey
        ]
        
        CRToastManager.dismissAllNotificationsWithIdentifier(_identifierKey, animated: false)
        CRToastManager.showNotificationWithOptions(options, completionBlock: completionBlock)
    }
}
