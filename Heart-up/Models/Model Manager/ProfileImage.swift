//
//  ProfileImage.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/09/09.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import Alamofire
import UIKit
import SwiftyJSON

class ProfileImage: NSObject {
    
    class func postImage(image: UIImage, callback: @escaping ([String: Any]?) -> Void) {
        // APIトークンがない場合はエラー.
        guard let auth_token = UserDefaults.standard.string(forKey: "auth_token") else {
            callback([ "message" : "ログインが必要です"])
            return
        }
        
        // URLを作成.
        let url = "http://localhost:3000/profile_images?auth_token=" + auth_token
        
        // リクエストヘッダーを作成.
        // ここでは multipart/form-data 形式でAPIを実行する.
        let headers : HTTPHeaders = [ "Content-type" : "multipart/form-data" ]
        
        let fileName = randomString(length: 10) + ".png" // 10桁のランダムな英数字を生成
        
        // multipart/form-data でAlamofireを実行.
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            // 送信データを詰める.
            multipartFormData.append(UIImageJPEGRepresentation(image, 0.8)!, withName: "file", fileName: fileName, mimeType: "image/png")
            print(multipartFormData)
            
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { result in
            
            // 結果別に処理する.
            switch result {
                
            // 成功した場合.
            case .success(let upload, _, _):
                // JSON形式でレスポンスを受け取る.
                upload.responseJSON { response in
                    // ステータスコードが成功(201)ではない場合
                    if response.response?.statusCode != 200 {
                        if let result = response.result.value as? [String: Any] {
                            // サーバーからのエラー情報があればそれを返す.
                            callback(result)
                        } else {
                            // なければエラー通知をする.
                            callback([ "message" : "サーバーエラーが発生しました" ])
                        }
                        return
                    }
                    // 成功の場合は、エラーなしで返却する.
                    callback(nil)
                }
                
            // 失敗した場合.
            case .failure(let error):
                // エラーを返却する.
                print(error)
                callback([ "message" : "サーバーエラーが発生しました" ])
            }
        }
    }
    
    //ランダムな文字列
    class func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
}

