
//
//  StockLocateInfos.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/08/24.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class StockLocateInfos: NSObject {
    class func postLocate(locate :LocateInfo, callback: @escaping ([String: Any]?) -> Void){
        
        //UserDefaultのauth_tokenを定義なかったら弾く
        guard let auth_token = UserDefaults.standard.string(forKey: "auth_token") else {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.showLoginStoryboard()
            }
            return
        }
        
        let url = "https://vast-brook-81265.herokuapp.com/locate_infos?auth_token=" + auth_token
//        let url = "http://localhost:3000/locate_infos?auth_token=" + auth_token


        let params = [
            "locate": [
                "nayami": locate.nayami,
                "ido": locate.ido,
                "keido": locate.keido,
                "color": locate.color
            ]
        ]
        
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
            callback(nil)
        }
    }
    
    class func getLocate(callback: @escaping ([String: Any]?, JSON?) -> Void) {
        
        // APIトークンがない場合はログイン画面へ.
        //UserDefaultのauth_tokenを定義なかったら弾く
        guard let auth_token = UserDefaults.standard.string(forKey: "auth_token") else {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.showLoginStoryboard()
            }
            return
        }
        
        let url = "https://vast-brook-81265.herokuapp.com/locate_infos?auth_token=" + auth_token
//          let url = "http://localhost:3000/locate_infos?auth_token=" + auth_token
        
        Alamofire.request(url, method: .get).responseJSON {response in
            //もしresponse.responseがnilだったら、電波のエラー画面をだす
            if response.response == nil {
                callback(["message": "電波が悪いか、サーバーの調子が悪い可能性があります、再読込してください"], nil)
                return
            }
            
            let statusCode = response.response!.statusCode
            // 失敗した場合.
            if statusCode != 200 {
                if statusCode == 401 {
                    callback(["message": "ユーザー情報がおかしい"], nil)
                    return
                }
                print("StockLocateInfosのgetLocate")
                callback(["message": "不明なサーバーエラー"], nil)
                return
            }
            
            
            guard let object = response.result.value else {
                return
            }
            
            let obj = JSON(object)
            
            callback(nil, obj)
        }

    }
    
    class func getDetailLocation(id: String, callback: @escaping ([String: Any]?, JSON?) -> Void) {
        //auth_tokenがないときはリターン
        guard let auth_token = UserDefaults.standard.string(forKey: "auth_token") else {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.showLoginStoryboard()
            }
            return
        }
        //Alamofireで検索
                let url = "https://vast-brook-81265.herokuapp.com/locate_infos/" + id + "?auth_token=" + auth_token
//        let url = "http://localhost:3000/locate_infos/" + id + "?auth_token=" + auth_token
        Alamofire.request(url, method: .get).responseJSON {response in
            //もしresponse.responseがnilだったら、電波のエラー画面をだす
            if response.response == nil {
                callback(["message": "電波が悪いか、サーバーの調子が悪い可能性があります、再読込してください"], nil)
                return
            }
            
            let statusCode = response.response!.statusCode
            // 失敗した場合.
            if statusCode != 200 {
                if statusCode == 401 {
                    callback(["message": "ユーザー情報がおかしい"], nil)
                    return
                }
                print("StockLocateInfosのgetLocate")
                callback(["message": "不明なサーバーエラー"], nil)
                return
            }
            
            let object = response.result.value            
            let obj = JSON(object)
            callback(nil, obj)
        }
    }
    
    class func getMyShabonDetailLocation(id: String, callback: @escaping ([String: Any]?, JSON?) -> Void) {
        //auth_tokenがないときはリターン
        guard let auth_token = UserDefaults.standard.string(forKey: "auth_token") else {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.showLoginStoryboard()
            }
            return
        }
        //Alamofireで検索
        let url = "https://vast-brook-81265.herokuapp.com/locate_infos/my_shabon/" + id + "?auth_token=" + auth_token
        //        let url = "http://localhost:3000/locate_infos/my_shabon/" + id + "?auth_token=" + auth_token
        Alamofire.request(url, method: .get).responseJSON {response in
            //もしresponse.responseがnilだったら、電波のエラー画面をだす
            if response.response == nil {
                callback(["message": "電波が悪いか、サーバーの調子が悪い可能性があります、再読込してください"], nil)
                return
            }
            
            let statusCode = response.response!.statusCode
            // 失敗した場合.
            if statusCode != 200 {
                if statusCode == 401 {
                    callback(["message": "ユーザー情報がおかしい"], nil)
                    return
                }
                print("StockLocateInfosのgetLocate")
                callback(["message": "不明なサーバーエラー"], nil)
                return
            }
            
            let object = response.result.value
            
            let obj = JSON(object)
            callback(nil, obj)
        }
    }
    
    //myShabonで自分が投稿したシャボン玉一覧を出すためのもの
    class func getMyShabon(callback: @escaping ([String: Any]?, [[String: Any]]?) -> Void) {
        //auth_tokenがないときはリターン
        guard let auth_token = UserDefaults.standard.string(forKey: "auth_token") else {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.showLoginStoryboard()
            }
            return
        }
        
        let url = "https://vast-brook-81265.herokuapp.com/locate_infos/find_my_shabon?auth_token=" + auth_token
//        let url = "http://localhost:3000/locate_infos/find_my_shabon?auth_token=" + auth_token
        Alamofire.request(url, method: .get).responseJSON {response in
            //もしresponse.responseがnilだったら、電波のエラー画面をだす
            if response.response == nil {
                callback(["message": "電波が悪いか、サーバーの調子が悪い可能性があります、再読込してください"], nil)
                return
            }
            
            let statusCode = response.response!.statusCode
            // 失敗した場合.
            if statusCode != 200 {
                if statusCode == 401 {
                    callback(["message": "ユーザー情報がおかしい"], nil)
                    return
                }
                print("StockLocateInfosのgetLocate")
                callback(["message": "不明なサーバーエラー"], nil)
                return
            }
            
            if let object = response.result.value as? [[String: Any]] {
            callback(nil, object)
            }
        }
    }
    
    //自分の情報をGET
    class func getMyProfile(callback: @escaping ([String: Any]?, JSON?) -> Void){
        //auth_tokenがないときはリターン
        guard let auth_token = UserDefaults.standard.string(forKey: "auth_token") else {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.showLoginStoryboard()
            }
            return
        }
        
        //user_idがないときはリターン
        guard let userId = UserDefaults.standard.string(forKey: "user_id") else {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.showLoginStoryboard()
            }
            return
        }
        
        //Alamofireで検索
                let url = "https://vast-brook-81265.herokuapp.com/users/" + userId + "?auth_token=" + auth_token
//        let url = "http://localhost:3000/users/" + userId + "?auth_token=" + auth_token
        Alamofire.request(url, method: .get).responseJSON {response in
            //もしresponse.responseがnilだったら、電波のエラー画面をだす
            if response.response == nil {
                callback(["message": "電波が悪いか、サーバーの調子が悪い可能性があります、再読込してください"], nil)
                return
            }
            
            let statusCode = response.response!.statusCode
            // 失敗した場合.
            if statusCode != 200 {
                if statusCode == 401 {
                    callback(["message": "ユーザー情報がおかしい"], nil)
                    return
                }
                print("StockLocateInfosのgetLocate")
                callback(["message": "不明なサーバーエラー"], nil)
                return
            }
            
            let obj = JSON(response.result.value)
            callback(nil, obj)
        }
    }
    
    //クリックしたユーザーのの情報をGET
    class func getSelectUser(userId: String, callback: @escaping ([String: Any]?, JSON?) -> Void){
        //auth_tokenがないときはリターン
        guard let auth_token = UserDefaults.standard.string(forKey: "auth_token") else {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.showLoginStoryboard()
            }
            return
        }
        
        //Alamofireで検索
                        let url = "https://vast-brook-81265.herokuapp.com/users/" + userId + "?auth_token=" + auth_token
//        let url = "http://localhost:3000/users/" + userId + "?auth_token=" + auth_token
        Alamofire.request(url, method: .get).responseJSON {response in
            //もしresponse.responseがnilだったら、電波のエラー画面をだす
            if response.response == nil {
                callback(["message": "電波が悪いか、サーバーの調子が悪い可能性があります、再読込してください"], nil)
                return
            }
            
            let statusCode = response.response!.statusCode
            // 失敗した場合.
            if statusCode != 200 {
                if statusCode == 401 {
                    callback(["message": "ユーザー情報がおかしい"], nil)
                    return
                }
                print("StockLocateInfosのgetLocate")
                callback(["message": "不明なサーバーエラー"], nil)
                return
            }
            
            
            let obj = JSON(response.result.value)
            callback(nil, obj)
        }
    }
    
}
