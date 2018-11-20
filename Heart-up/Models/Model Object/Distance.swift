//
//  Distance.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/10/02.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

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
    
    class func setUpJapan(map: MKMapView){
        // 中心点の緯度経度.
        let myLat: CLLocationDegrees = 38.0
        let myLon: CLLocationDegrees = 138.0
        let myCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(myLat, myLon) as CLLocationCoordinate2D
        
        // 縮尺.
        let myLatDist : CLLocationDistance = 2000000
        let myLonDist : CLLocationDistance = 2000000
        // Regionを作成.
        let myRegion: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(myCoordinate, myLatDist, myLonDist);
        // MapViewに反映.
        map.setRegion(myRegion, animated: true)
    }
}
