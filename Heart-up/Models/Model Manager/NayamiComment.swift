//
//  NayamiComment.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/09/02.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NayamiComment: NSObject {
    class func nayamiCommentPost(locate_info_id: Int, comment: String?, stampId: Int?, callback: @escaping ([String: Any]?) -> Void) {
        guard let auth_token = UserDefaults.standard.string(forKey: "auth_token") else {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.showLoginStoryboard()
            }
            return
        }
                let url = "https://vast-brook-81265.herokuapp.com/nayami_comments?auth_token=" + auth_token
//        let url = "http://localhost:3000/nayami_comments?auth_token=" + auth_token
        
        //numberかstringで分岐
        let params: [String : [String : Any]]
        
        if let comment = comment {
            params = [
                "nayami_comment": [
                    "locate_info_id": locate_info_id,
                    "nayami_comment": comment
                ]
            ]
        } else if let stampId = stampId {
            params = [
                "nayami_comment": [
                    "locate_info_id": locate_info_id,
                    "stamp_id": stampId
                ]
            ]
        } else {
            print("ここここで何らかのエラー文を出力してください")
            return
        }
        
        
        Alamofire.request(url, method: .post, parameters: params).responseJSON { response in
            switch response.result {
            case .success:
                if response.response?.statusCode != 200 {
                    if let result = response.result.value as? [String: Any] {
                        callback(result)
                    } else {
                        callback([ "message" : "サーバーエラーが発生しました" ])
                    }
                    return
                }
                callback(nil)
                
            case .failure(let error):
                print(error)
                callback(["message": "サーバーエラーが発生しました"])
            }
        }
    }
    
    //myShabonでPostしたシャボン玉一覧を出すためのもの
    class func getPostShabon(callback: @escaping ([String: Any]?, [[String: Any]]?) -> Void) {
        //auth_tokenがないときはリターン
        guard let auth_token = UserDefaults.standard.string(forKey: "auth_token") else {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.showLoginStoryboard()
            }
            return
        }
        let url = "https://vast-brook-81265.herokuapp.com/nayami_comments/my_post/?auth_token=" + auth_token
//        let url = "http://localhost:3000/nayami_comments/my_post/?auth_token=" + auth_token
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
    
    //自分のシャボン玉につけられた悩みがあるかどうか検索
    class func myShabonNayamiFind(callback: @escaping ([String: Any]?, [[String: Any]]?) -> Void){
        //auth_tokenがないときはリターン
        guard let auth_token = UserDefaults.standard.string(forKey: "auth_token") else {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.showLoginStoryboard()
            }
            return
        }
        let url = "https://vast-brook-81265.herokuapp.com/nayami_comments/my_shabon_nayami_find/?auth_token=" + auth_token
//        let url = "http://localhost:3000/nayami_comments/my_shabon_nayami_find/?auth_token=" + auth_token
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
    
    //locate_idにrailsでpostしてnayami_commentsをtrueにする
    class func fixYondaFlag(id: String, callback: @escaping ([String: Any]?) -> Void){
        //auth_tokenがないときはリターン
        guard let auth_token = UserDefaults.standard.string(forKey: "auth_token") else {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.showLoginStoryboard()
            }
            return
        }
        let url = "https://vast-brook-81265.herokuapp.com/nayami_comments/fix_yonda_flag/" + id + "?auth_token=" + auth_token
//        let url = "http://localhost:3000/nayami_comments/fix_yonda_flag/" + id + "?auth_token=" + auth_token
        Alamofire.request(url, method: .get).responseJSON {response in
            //電波が悪い時
            if !response.result.isSuccess {
                return
            }
            let statusCode = response.response!.statusCode
            
            //失敗したとき
            if statusCode != 200 {
                callback(["message": "電波が悪い可能性があります。再読み込みをお願いします"])
            }
                callback(nil)
        }
    }
    
    
}
