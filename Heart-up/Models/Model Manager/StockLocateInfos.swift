
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
    class func postLocate(locate :LocateInfo){
        let url = "https://aqueous-temple-50173.herokuapp.com/locate_infos"

        let params = [
            "locate": [
                "ido": locate.ido,
                "keido": locate.keido
            ]
        ]
        
        Alamofire.request(url, method: .post, parameters: params)
        
    }
    
    class func getLocate(callback: @escaping ([String: Any]?, [String: Any]?) -> Void) {
        let url = "http://localhost:3000/locate_infos"
        Alamofire.request(url, method: .get).responseJSON {response in
            
            let statusCode = response.response!.statusCode
            
            // 失敗した場合.
            if statusCode != 200 {
                callback([ "message" : "サーバーでエラーが発生しました。"], nil)
            }
            
            if let obj = response.result.value as? [String: Any]? {
                callback(nil, obj)
            }
        }

    }
    
}
