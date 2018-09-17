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
    class func setAnnotation(x: Double,y: Double, map: MKMapView?, id: Int, nayami: String, user_id: Int, user_name: String, color: String) ->Void {
        //StringをDouble型に変換
        let annotation = CustomAnnotation()
        //独自のクラスを使用
        annotation.color = ["color": color as AnyObject]
        annotation.locateId = ["locateId": id as AnyObject]
        annotation.coordinate = CLLocationCoordinate2DMake(x,y)
        annotation.title = nayami
//        annotation.subtitle = "\(annotation.coordinate.latitude), \(annotation.coordinate.longitude)"
        annotation.subtitle = "\(String(id))番目の悩みの投稿者は\(user_name)さんです"
        map!.addAnnotation(annotation)
    }
    
    class func setUserAnnotation(x: Double,y: Double, map: MKMapView?, userId: Int, userName: String, userImage: String) ->Void {
        //StringをDouble型に変換
        let annotation = UserAnnotation()
        //独自のクラスを使用
        annotation.userImage = ["userImage": userImage as AnyObject]
        annotation.userId = ["userId": userId as AnyObject]
        annotation.coordinate = CLLocationCoordinate2DMake(x,y)
        annotation.title = userName
        map!.addAnnotation(annotation)
    }
}
