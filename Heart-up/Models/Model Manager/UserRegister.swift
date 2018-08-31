//
//  UserRegister.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/08/31.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class UserRegister: NSObject {
    class func postLocate(user: [String: Any]){
//        let url = "https://aqueous-temple-50173.herokuapp.com/users"
        let url = "http://localhost:3000/users"
        
        let params = [
            "user": [
                "user_name": user["user_name"],
                "email": user["email"],
                "password_digest": user["password"]
            ]
        ]
        
        Alamofire.request(url, method: .post, parameters: params).responseJSON { response in
            switch response.result {
            case .success:
                let success = response.result.value
                print(success)
            case .failure:
                print("失敗")
            }
        }
    }
}
