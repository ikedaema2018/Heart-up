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
    class func reactionPost(commentId: Int?, nayamiOrReply: Int?, reactionId: Int?, callback: @escaping ([String: Any]?) -> Void) {
        guard let auth_token = UserDefaults.standard.string(forKey: "auth_token") else {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.showLoginStoryboard()
            }
            return
        }
        
        let url = "https://vast-brook-81265.herokuapp.com/reactions?auth_token=" + auth_token
        guard let commentId = commentId, let nayamiOrReply = nayamiOrReply, let reactionId = reactionId else {
            //エラー処理
            return
        }

        //numberかstringで分岐
        let params: [String : [String : Any]]
        
        if nayamiOrReply == 1 {
            params = [
                "reaction": [
                    "nayami_comment_id": commentId,
                    "reaction_id": reactionId
                ]
            ]
        } else if nayamiOrReply == 2 {
            params = [
                "reaction": [
                    "reply_comment_id": commentId,
                    "reaction_id": reactionId
                ]
            ]
        } else {
            print("ここここで何らかのエラー文を出力してください")
            return
        }
        Alamofire.request(url, method: .post, parameters: params).responseJSON { response in
            //電波が悪い時
            if !response.result.isSuccess {
                return
            }
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
