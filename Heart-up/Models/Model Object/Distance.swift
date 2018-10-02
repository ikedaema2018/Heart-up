//
//  Distance.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/10/02.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit

class Distance: NSObject {
    
    class func distance(current: (la: Double, lo: Double), target: (la: Double, lo: Double)) -> Double {
        
        // 緯度経度をラジアンに変換
        let currentLa   = current.la * Double.pi / 180
        let currentLo   = current.lo * Double.pi / 180
        let targetLa    = target.la * Double.pi / 180
        let targetLo    = target.lo * Double.pi / 180
        
        // 赤道半径
        let equatorRadius = 6378137.0;
        
        // 算出
        let averageLat = (currentLa - targetLa) / 2
        let averageLon = (currentLo - targetLo) / 2
        let distance = equatorRadius * 2 * asin(sqrt(pow(sin(averageLat), 2) + cos(currentLa) * cos(targetLa) * pow(sin(averageLon), 2)))
        return distance / 1000
    }
}
