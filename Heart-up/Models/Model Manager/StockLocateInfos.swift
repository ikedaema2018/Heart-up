
//
//  StockLocateInfos.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/08/24.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit
import Alamofire


class StockLocateInfos: NSObject {
    class func postLocate(locate :LocateInfo){
        let params = [
            "locate": [
                "ido": locate.ido,
                "keido": locate.keido
            ]
        ]
        
        Alamofire.request("https://aqueous-temple-50173.herokuapp.com/locate_infos", method: .post, parameters: params)
        
    }
}
