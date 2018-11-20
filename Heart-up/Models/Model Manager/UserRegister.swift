//
//  UserRegister.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/08/31.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class UserRegister: NSObject {
    class func postLocate(user: [String: String], callback: @escaping ([String: Any]?, [String: Any]?) -> Void){
        
        let url = "https://vast-brook-81265.herokuapp.com/users"
//        let url = "http://localhost:3000/users"
        
        let params = [
            "user": [
                "user_name": user["user_name"]!,
                "email": user["email"]!,
                "password": user["password"]!,
                "age": Int(user["age"]!),
                "gender": user["gender"]!,
                "self_introduce": user["self_introduce"]!,
                "password_confirm": user["password_confirm"]
            ]
        ]
        
        Alamofire.request(url, method: .post, parameters: params).responseJSON { response in
            switch response.result {
            case .success:
                if response.response?.statusCode != 200 && response.response?.statusCode != 201 {
                    if let result = response.result.value as! [String: Any]? {
                        callback(nil, result)
                    } else {
                        callback(nil, [ "message" : "サーバーエラーが発生しました" ])
                    }
                    return
                }
                callback(response.result.value as? [String: Any], nil)
                
            case .failure(let error):
                callback(nil, ["message": "サーバーエラーが発生しました"])
            }
        }
    }
    
    class func updateIntroduce(intro: String, callback: @escaping ([String: Any]?) -> Void) {
        //UserDefaultのauth_tokenを定義なかったら弾く
        guard let auth_token = UserDefaults.standard.string(forKey: "auth_token") else {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.showLoginStoryboard()
            }
            return
        }
        let params = [
            "self_introduce": intro
        ]
                let url = "https://vast-brook-81265.herokuapp.com/users/intro_update?auth_token=" + auth_token
//        let url = "http://localhost:3000/users/intro_update?auth_token=" + auth_token
        
        Alamofire.request(url, method: .post, parameters: params).responseJSON { response in
            //もしresponse.responseがnilだったら、電波のエラー画面をだす
            if response.response == nil {
                callback(["message": "電波が悪いか、サーバーの調子が悪い可能性があります、再読込してください"])
                return
            }
            
            let statusCode = response.response!.statusCode
            // 失敗した場合.
            if statusCode != 200 {
                if statusCode == 401 {
                    callback(["message": "ユーザー情報がおかしい"])
                    return
                }
                print("StockLocateInfosのgetLocate")
                callback(["message": "不明なサーバーエラー"])
                return
            }
            callback(nil
            )
        }
    }
    
}
