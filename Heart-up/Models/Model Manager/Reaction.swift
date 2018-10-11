//
//  Reaction.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/10/11.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class Reaction {
    class func reactionPost(nayamiCommentId: Int?, replyCommentId: Int?, reactionId: Int?, callback: @escaping ([String: Any]?) -> Void) {
        guard let auth_token = UserDefaults.standard.string(forKey: "auth_token") else {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.showLoginStoryboard()
            }
            return
        }
        let url = "https://vast-brook-81265.herokuapp.com/reactions?auth_token=" + auth_token
        
        //numberかstringで分岐
        let params: [String : [String : Any]]
        
        if let nayamiCommentId = nayamiCommentId {
            params = [
                "reaction": [
                    "nayami_comment_id": nayamiCommentId,
                    "reaction_id": reactionId as Any
                ]
            ]
        } else if let replyCommentId = replyCommentId {
            params = [
                "reaction": [
                    "reply_comment_id": replyCommentId,
                    "reaction_id": reactionId as Any
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
}
