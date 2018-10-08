//
//  ReplyComment.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/10/07.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit
import Alamofire

class ReplyComment: NSObject {
    class func replyCommentPost(nayami_comment_id: Int, comment: String, callback: @escaping ([String: Any]?) -> Void) {
        guard let auth_token = UserDefaults.standard.string(forKey: "auth_token") else {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.showLoginStoryboard()
            }
            return
        }
        let url = "https://vast-brook-81265.herokuapp.com/reply_comments?auth_token=" + auth_token
        //        let url = "http://localhost:3000/nayami_comments?auth_token=" + auth_token
           let params = [
                "reply_comment": [
                    "nayami_comment_id": nayami_comment_id,
                    "reply_comment": comment
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
