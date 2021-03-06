//
//  PushToken.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/09/22.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit
import Alamofire

class PushToken: NSObject {
    class func postToken(userId: String, fcmToken: String, callback: @escaping ([String: Any]?) -> Void){
        //UserDefaultのauth_tokenを定義なかったら弾く
        guard let auth_token = UserDefaults.standard.string(forKey: "auth_token") else {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.showLoginStoryboard()
            }
            return
        }
        //let url = "http://localhost:3000/push_infos?auth_token=" + auth_token
        let url = "https://vast-brook-81265.herokuapp.com/push_infos?auth_token=" + auth_token
        let headers :HTTPHeaders = [ "Content-type": "application/json" ]
        let params: [String: Any] = [
            "push_infos": [
                "fcm_token": fcmToken,
                "user_id": userId
            ]
        ]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                //電波が悪い時
                if !response.result.isSuccess {
                    return
                }
                let statusCode = response.response!.statusCode
                
                //失敗
                if statusCode != 200 {
                    if let errorInfo = response.result.value as? [String: Any] {
                        callback([ "message" : "電波が悪い可能性があります。再読み込みをお願いします"])
                    }
                    return
                }
                
                //成功した場合
                callback(nil)
        }

    }
}

//9784873114880
