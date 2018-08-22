//
//  ViewController.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/08/21.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class ViewController: UIViewController, MKMapViewDelegate  {
    @IBOutlet weak var testMapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let x = 140.000000 //経度
        let y = 35.000000  //緯度
        
        //中心座標
        let center = CLLocationCoordinate2DMake(y, x)
        
        //表示範囲
        let span = MKCoordinateSpanMake(1.0, 1.0)
        
        //中心座標と表示範囲をマップに登録する。
        let region = MKCoordinateRegionMake(center, span)
        testMapView.setRegion(region, animated:true)
        
        //中心にピンを立てる。
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(y, x)
        annotation.title = "中心"
        annotation.subtitle = "\(annotation.coordinate.latitude), \(annotation.coordinate.longitude)"
        testMapView.addAnnotation(annotation)
        
        //左下のピン
        let annotation1 = MKPointAnnotation()
        annotation1.coordinate = CLLocationCoordinate2DMake(y-1.0, x-1.0)
        annotation1.title = "左下"
        annotation1.subtitle = "\(annotation1.coordinate.latitude), \(annotation1.coordinate.longitude)"
        testMapView.addAnnotation(annotation1)
        
        //右下のピン
        let annotation2 = MKPointAnnotation()
        annotation2.coordinate = CLLocationCoordinate2DMake(y-1.0, x+1.0)
        annotation2.title = "右下"
        annotation2.subtitle = "\(annotation2.coordinate.latitude), \(annotation2.coordinate.longitude)"
        testMapView.addAnnotation(annotation2)
        
        //左上のピン
        let annotation3 = MKPointAnnotation()
        annotation3.coordinate = CLLocationCoordinate2DMake(y+1.0, x-1.0)
        annotation3.title = "左上"
        annotation3.subtitle = "\(annotation3.coordinate.latitude), \(annotation3.coordinate.longitude)"
        testMapView.addAnnotation(annotation3)
        
        //右上のピン
        let annotation4 = MKPointAnnotation()
        annotation4.coordinate = CLLocationCoordinate2DMake(y+1.0, x+1.0)
        annotation4.title = "右上"
        annotation4.subtitle = "\(annotation4.coordinate.latitude), \(annotation4.coordinate.longitude)"
        testMapView.addAnnotation(annotation4)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}

