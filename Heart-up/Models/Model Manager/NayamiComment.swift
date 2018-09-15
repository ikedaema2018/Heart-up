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
    class func nayamiCommentPost(locate_info_id: Int, comment: String, callback: @escaping ([String: Any]?) -> Void) {
        guard let auth_token = UserDefaults.standard.string(forKey: "auth_token") else {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.showLoginStoryboard()
            }
            return
        }
//                let url = "https://aqueous-temple-50173.herokuapp.com/nayami_comments?auth_token=" + auth_token
        let url = "http://localhost:3000/nayami_comments?auth_token=" + auth_token
         let params = [
            "nayami_comment": [
                "locate_info_id": locate_info_id,
                "nayami_comment": comment
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
                callback(["message": "サーバーエラーが発生しました"])
            }
        }
    }
}
