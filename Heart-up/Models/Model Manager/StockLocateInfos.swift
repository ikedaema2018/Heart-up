
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
    
    class func getLocate(){
        let url = "http://localhost:3000/locate_infos"
        Alamofire.request(url, method: .get).responseJSON{response in
            guard let obj = response.result.value else {
                return
            }
            let json = JSON(obj)
            print(json["keido"])
        }
    }
    
}
