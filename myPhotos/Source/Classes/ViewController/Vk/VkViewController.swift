//
//  VkViewController.swift
//  myPhotos
//
//  Created by Мария on 01.09.16.
//  Copyright © 2016 Мария. All rights reserved.
//

import Foundation
import UIKit
import VK_ios_sdk

class VkViewController: ViewController, VKSdkDelegate, VKSdkUIDelegate {
    
    let VKInstanse:VKSdk = VKSdk.initializeWithAppId(Constants.VK_APP_ID)
    
    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    
    // MARK: - VK auth
    func vkLoad() {
        VKInstanse.registerDelegate(self)
        VKInstanse.uiDelegate = self
        weak var weakSelf = self
        VKSdk.wakeUpSession(Constants.VK_SCOPE) { (state, error) -> Void in
            if state == VKAuthorizationState.Authorized {
                weakSelf!.loadData()
            } else if error != nil {
                weakSelf!.setData()
                weakSelf!.showMessage(MessageType.Error, title: nil, subTitle: error.localizedDescription)
            } else {
                VKSdk.authorize(Constants.VK_SCOPE)
            }
        }
    }
    
    func setData() {}
    
    // MARK: - Load
    func loadData(){}
    
    // MARK: - VKSdkDelegate, VKSdkUIDelegate
    func vkSdkShouldPresentViewController(controller: UIViewController!) {
        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }
    
    func vkSdkNeedCaptchaEnter(captchaError: VKError!) {
        //TODO
        print("vkSdkNeedCaptchaEnter")
    }
    
    func vkSdkAccessAuthorizationFinishedWithResult(result: VKAuthorizationResult!) {
        self.loadData()
    }
    
    func vkSdkUserAuthorizationFailed() {
        self.setData()
        self.showMessage(MessageType.Error, title: nil, subTitle: "")
        
    }
}