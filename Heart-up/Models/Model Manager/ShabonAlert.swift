//
//  ShabonAlert.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/09/10.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ShabonAlert: NSObject {
    class func select_user_alert(callback: @escaping ([String: Any]?, JSON?) -> Void){
        guard let auth_token = UserDefaults.standard.string(forKey: "auth_token") else {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.showLoginStoryboard()
            }
            return
        }
                let url = "https://aqueous-temple-50173.herokuapp.com/shabon_alerts/show?auth_token=" + auth_token
//        let url = "http://localhost:3000/shabon_alerts/show?auth_token=" + auth_token
        
        Alamofire.request(url, method: .get).responseJSON {response in
            let statusCode = response.response!.statusCode
            
            // 失敗した場合.
            if statusCode != 200 {
                callback([ "message" : "サーバーでエラーが発生しました。 ShabonAlert"], nil)
            }
            
            if statusCode == 201 {
                return
            }
            
            guard let object = response.result.value else {
                return
            }
            
            let obj = JSON(object)
            callback(nil, obj)
        }

    }
    
    
    class func fixAlert(id: Int, _ callback: @escaping ([String: Any]?) -> Void ) {
        guard let auth_token = UserDefaults.standard.string(forKey: "auth_token") else {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.showLoginStoryboard()
            }
            return
        }
//        guard let id = id else {
//            callback(nil)
//            return
//        }
        
                let url = "https://aqueous-temple-50173.herokuapp.com/shabon_alerts/" + String(id) + "?auth_token=" + auth_token
//        let url = "http://localhost:3000/shabon_alerts/" + String(id) + "?auth_token=" + auth_token
        
        Alamofire.request(url, method: .get).responseJSON {response in
            let statusCode = response.response!.statusCode
            // 失敗した場合.
            if statusCode != 200 {
                callback([ "message" : "サーバーでエラーが発生しました。"])
            }
            
            callback(nil)
        }
    }
    
    class func closeAlert(callback: @escaping ([String: Any]?, JSON?) -> Void) {
        guard let auth_token = UserDefaults.standard.string(forKey: "auth_token") else {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.showLoginStoryboard()
            }
            return
        }
                        let url = "https://aqueous-temple-50173.herokuapp.com/closer_alerts?auth_token=" + auth_token
//        let url = "http://localhost:3000/closer_alerts?auth_token=" + auth_token
        
        Alamofire.request(url, method: .get).responseJSON {response in
            let statusCode = response.response!.statusCode
            
            // 失敗した場合.
            if statusCode != 200 {
                callback([ "message" : "サーバーでエラーが発生しました。 closeAlert"], nil)
            }
            
            if statusCode == 201 {
                return
            }
            
            guard let object = response.result.value else {
                return
            }
            let obj = JSON(object)
            callback(nil, obj)
        }
    }
    
    class func fixClose(id: Int, _ callback: @escaping ([String: Any]?) -> Void ) {
        guard let auth_token = UserDefaults.standard.string(forKey: "auth_token") else {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.showLoginStoryboard()
            }
            return
        }

                        let url = "https://aqueous-temple-50173.herokuapp.com/closer_alerts/" + String(id) + "?auth_token=" + auth_token
//        let url = "http://localhost:3000/closer_alerts/" + String(id) + "?auth_token=" + auth_token
        
        Alamofire.request(url, method: .get).responseJSON {response in
            let statusCode = response.response!.statusCode
            // 失敗した場合.
            if statusCode != 200 {
                callback([ "message" : "サーバーでエラーが発生しました。"])
            }
            callback(nil)
        }
    }
}
