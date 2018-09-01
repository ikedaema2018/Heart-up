
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
        
//        let url = "https://aqueous-temple-50173.herokuapp.com/locate_infos?auth_token=" + auth_token
        let url = "http://localhost:3000/locate_infos?auth_token=" + auth_token
//

        let params = [
            "locate": [
                "nayami": locate.nayami,
                "ido": locate.ido,
                "keido": locate.keido
            ]
        ]
        
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
                callback(["message": "んんサーバーエラーが発生しました"])
            }
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
        
//        let url = "https://aqueous-temple-50173.herokuapp.com/locate_infos?auth_token=" + auth_token
          let url = "http://localhost:3000/locate_infos?auth_token=" + auth_token
        
        Alamofire.request(url, method: .get).responseJSON {response in
            
            let statusCode = response.response!.statusCode
            
            
            
            // 失敗した場合.
            if statusCode != 200 {
                callback([ "message" : "サーバーでエラーが発生しました。StockLocateController"], nil)
            }
            
            
            
            guard let object = response.result.value else {
                return
            }
            
            let obj = JSON(object)
            
            
            callback(nil, obj)
        }

    }
    
}
