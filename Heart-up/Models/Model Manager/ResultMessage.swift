//
//  ResultMessage.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/10/21.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit
import Alamofire

class ResultMessage: NSObject {
    class func postResultMessage(locate_info_id: Int, message: String, callback: @escaping ([String: Any]?) -> Void){
        guard let auth_token = UserDefaults.standard.string(forKey: "auth_token") else {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.showLoginStoryboard()
            }
            return
        }
        let url = "https://vast-brook-81265.herokuapp.com/result_messages/update?auth_token=" + auth_token
        let params = ["result_messages":
            ["result_message": message, "locate_info_id": locate_info_id]
        ]
        Alamofire.request(url, method: .post, parameters: params).responseJSON { (response) in
            
            guard let result = response.response else {
                callback([ "message" : "電波が悪い可能性があります。再読み込みをお願いします"])
                return
            }
            let statusCode = response.response!.statusCode
            
            if statusCode != 200 {
                if let errorInfo = response.result.value as? [String: Any] {
                    callback([ "message" : "電波が悪い可能性があります。再読み込みをお願いします"])
                }
                callback([ "message" : "電波が悪い可能性があります。再読み込みをお願いします"])
            }
            //成功したら
            callback(nil)
        }
    }
}
