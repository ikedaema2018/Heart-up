//
//  MapModule.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/08/25.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapModule: NSObject  {
    class func setAnnotation(x: String,y: String, map: MKMapView?, id: Int, nayami: String, user_id: Int, user_name: String, color: String) ->Void {
        //StringをDouble型に変換
        let annotation = CustomAnnotation()
        //独自のクラスを使用
        annotation.color = ["color": color as AnyObject]
        annotation.locateId = ["locateId": id as AnyObject]
        annotation.coordinate = CLLocationCoordinate2DMake(Double(x)!,Double(y)!)
        annotation.title = nayami
//        annotation.subtitle = "\(annotation.coordinate.latitude), \(annotation.coordinate.longitude)"
        annotation.subtitle = "\(String(id))番目の悩みの投稿者は\(user_name)さんです"
        map!.addAnnotation(annotation)
    }
}
