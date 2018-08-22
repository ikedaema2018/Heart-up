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


class ViewController: UIViewController {
    @IBOutlet weak var testMapView: MKMapView!
    //CLLocationManagerの入れ物を用意
    var myLocationManager:CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //CLLocationManagerをインスタンス化
        myLocationManager = CLLocationManager()
        
        
        //位置情報使用許可のリクエストを表示するメソッドの呼び出し
        myLocationManager.requestWhenInUseAuthorization()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //位置情報取得に失敗したときに呼び出されるメソッド
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error")
    }

}

