//
//  UserLocate.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/09/13.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class UserLocate: NSObject {
    class func userLocateUpdate(ido: String, keido: String, callback: @escaping ([String: Any]?) -> Void) {
        guard let auth_token = UserDefaults.standard.string(forKey: "auth_token") else {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.showLoginStoryboard()
            }
            return
        }
                let url = "https://vast-brook-81265.herokuapp.com/user_locates/update?auth_token=" + auth_token
//        let url = "http://localhost:3000/user_locates/update?auth_token=" + auth_token
        let params = [
            "user_locate": [
                "ido": ido,
                "keido": keido
            ]
        ]
        
        Alamofire.request(url, method: .post, parameters: params).responseJSON { response in
            //電波が悪い時
            if !response.result.isSuccess {
               callback([ "message" : "電波が悪い可能性があります。再読み込みをお願いします"])
                return
            }
            let statusCode = response.response!.statusCode
            // 失敗した場合.
            if statusCode != 200 {
                callback([ "message" : "電波が悪い可能性があります。再読み込みをお願いします"])
            }
            callback(nil)
        }
            
    }
    class func currentUser(callback: @escaping ([String: Any]?, JSON?) -> Void){
        guard let auth_token = UserDefaults.standard.string(forKey: "auth_token") else {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.showLoginStoryboard()
            }
            return
        }
                        let url = "https://vast-brook-81265.herokuapp.com/users/one_hour_ago_user?auth_token=" + auth_token
//        let url = "http://localhost:3000/users/one_hour_ago_user?auth_token=" + auth_token
        Alamofire.request(url, method: .get).responseJSON {response in
            
            //電波が悪い時
            if !response.result.isSuccess {
                callback([ "message" : "電波が悪い可能性があります。再読み込みをお願いします"], nil)
                return
            }
            let statusCode = response.response!.statusCode
            // 失敗した場合.
            if statusCode != 200 {
                callback([ "message" : "電波が悪い可能性があります。再読み込みをお願いします"], nil)
            }
            guard let object = response.result.value else {
                return
            }
            
            let obj = JSON(object)
            
            callback(nil, obj)
        }

    }
}
