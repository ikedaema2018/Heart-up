//
//  Api.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/08/30.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import Foundation
import Alamofire

//let apiRoot = "http://localhost:3000"
let apiRoot = "https://vast-brook-81265.herokuapp.com/"

class ApiManager {
    static let shared = ApiManager()
    
    func login(loginEmail: String, loginPassword: String, callback: @escaping (([String: String]?) -> Void)){
        let url = apiRoot + "/admin"
        let headers :HTTPHeaders = [ "Content-type": "application/json" ]
        let params: [String: Any] = [
            "admin": [
                "email": loginEmail,
                "password": loginPassword
                ]
        ]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                //電波が悪い時
                guard let res = response.response else {
                    callback([ "message" : "電波が悪い可能性があります。再読み込みをお願いします"])
                    return
                }
                let statusCode = res.statusCode
                
                //失敗
                if statusCode != 200 {
                    if let errorInfo = response.result.value as? [String: String] {
                        callback([ "message" : "パスワードが間違っているか、メールアドレスが違います"])
                        return
                    }
                    callback([ "message" : "パスワードが間違っているか、メールアドレスが違います"])
                    return
                }
                
                //成功した場合
                if let data = response.result.value as? [String: Any] {
                    print(data)
                    
                    //ユーザーIDを保存
                    if let userId = data["id"] as? Int {
                        UserDefaults.standard.set(userId, forKey: "user_id")
                    }
                    
                    if let auth_token = data["auth_token"] as? String {
                        UserDefaults.standard.set(auth_token, forKey: "auth_token")
                    }
                }
                callback(nil)
        }
        
    }
}
