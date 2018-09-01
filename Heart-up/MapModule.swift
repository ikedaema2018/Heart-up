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
    
    class func setAnnotation(x: String,y: String, map: MKMapView?, id: Int, nayami: String, user_id: Int) ->Void {
        //StringをDouble型に変換
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(Double(x)!,Double(y)!)
        annotation.title = nayami
//        annotation.subtitle = "\(annotation.coordinate.latitude), \(annotation.coordinate.longitude)"
        annotation.subtitle = "\(String(id))番目の悩みの投稿者は\(user_id)さんです"
        map!.addAnnotation(annotation)
    }
}
