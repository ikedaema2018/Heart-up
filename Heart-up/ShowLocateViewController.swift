//
//  ShowLocateViewController.swift
//  
//
//  Created by 前田啓 on 2018/08/24.
//

import UIKit
import MapKit
import SwiftyJSON
import CoreLocation


class ShowLocateViewController: UIViewController, MKMapViewDelegate {
    
    //常に更新される緯度経度を定義
    var latitude :String?
    var longitude :String?
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager : CLLocationManager?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if locationManager != nil { return }
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager!.startUpdatingLocation()
        }
        
        locationManager!.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager!.distanceFilter = 1000
        
        //UserDefaltsを初期化したい時
//        let userDefaults = UserDefaults.standard
//        userDefaults.removeObject(forKey: "auth_token")
//        userDefaults.removeObject(forKey: "user_id")
        
        mapView.delegate = self
        // tracking user location
        mapView.userTrackingMode = MKUserTrackingMode.followWithHeading
        mapView.showsUserLocation = true
        
        
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation === mapView.userLocation {
            return nil
        } else {
            if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotation") {
                return annotationView
            } else {
                let anno = MKAnnotationView(annotation: annotation, reuseIdentifier: "anno")
                anno.annotation = annotation
                
                anno.canShowCallout = true
                
                //annoのクラス名を・・・意味不明だから省略
                // ( annotation as! CustomAnnotation )をしないと
                // CustomAnnotationクラスで定義した変数が取れないので注意！
                if let color = (( annotation as! CustomAnnotation ).color["color"]) {
                    let color_s = color as! String
                    
                    if color_s  == "黄" {
                        anno.image = UIImage(named: "yellow")
                    } else if color_s == "青" {
                        anno.image = UIImage(named: "blue")
                    } else if color_s == "赤" {
                        anno.image = UIImage(named: "red")
                    }
                } else {
                    print("だめ")
                }
                return anno
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        //クリックした時、ユーザーだったらリターン
        if view.annotation is MKUserLocation {
            return
        }
        
        guard let locateId = (view.annotation as! CustomAnnotation).locateId["locateId"] else {
            return
        }

        
        let locate_id = locateId as! Int
        
        
        //遷移
        performSegue(withIdentifier: "toDetailShabonViewController", sender: String(locate_id))
    }
    
    //ページ遷移で数値を
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let locateId = sender as? String else {
            return
        }
        
        if segue.identifier == "toDetailShabonViewController" {
            if let vc = segue.destination as? detailShabonViewController {
                vc.locateId = locateId
            }
        } else if segue.identifier == "toCloserDetailSegue" {
            if let vc = segue.destination as? CloserDetailCollectionViewController {
                vc.locateId = locateId
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view.
        
        //一旦ピン削除
        removeAllAnnotations()
        fetchData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after loading the view.
        
        
        //shabon_alert テーブルから検索する処理
        select_user_alert()
        closer_alert()
    }
    
}

extension ShowLocateViewController {
    func fetchData(){
        StockLocateInfos.getLocate {error, locates in
            
            if let error = error {
                if let message = error["message"] as? String {
                    print(message)
                    print("不明なエラーが発生しました")
                } else {
                    print("不明なエラーが発生しました")
                }
                return
            }
            
            guard let locates = locates else {
                return
            }

           
            //ピンを一覧で表示
            locates.forEach { (_, locate) in
                if let ido_s = locate["ido"].double, let keido_s = locate["keido"].double, let id_i = locate["id"].int, let nayami = locate["nayami"].string, let user_id = locate["user_id"].int, let color = locate["color"].string, let user_name = locate["user"]["user_name"].string {
                    MapModule.setAnnotation(x: ido_s, y: keido_s, map: self.mapView, id: id_i, nayami: nayami, user_id: user_id, user_name: user_name, color: color)
                }
            }
        }
    }
    
    func removeAllAnnotations() {
        let annotations = mapView.annotations.filter {
            $0 !== self.mapView.userLocation
        }
        mapView.removeAnnotations(annotations)
    }
    
//    func alert_shabon(alert: JSON, num: Int){
//        print(alert[num])
//        let aaa = num + 1
//        //alert
//        if aaa >= alert.count {
//            //updateの処理
//            return
//        }
//        alert_shabon(alert: alert, num: aaa)
//    }
}

extension ShowLocateViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways, .authorizedWhenInUse:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else {
            return
        }
        
        let location:CLLocationCoordinate2D
            = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude)
        
        latitude = "".appendingFormat("%.4f", location.latitude)
        longitude = "".appendingFormat("%.4f", location.longitude)
        
        //自分の緯度、経度をupdate
        user_locate_update(ido: latitude!, keido: longitude!)
        
        // update annotation
        //        mapView.removeAnnotations(mapView.annotations)
        //
        //        let annotation = MKPointAnnotation()
        //        annotation.coordinate = newLocation.coordinate
        //        mapView.addAnnotation(annotation)
        //        mapView.selectAnnotation(annotation, animated: true)
        
        // Showing annotation zooms the map automatically.
        //        mapView.showAnnotations(mapView.annotations, animated: true)
        
    }
}

extension ShowLocateViewController {
    func user_locate_update(ido: String, keido: String) -> Void {
        UserLocate.userLocateUpdate(ido: ido, keido: keido, callback: { response in
            if let error = response {
                let error_message = error["message"] as! String
                self.showAlert(message: error_message, hide: {})
            }
        })
    }
    func select_user_alert() {
        ShabonAlert.select_user_alert(callback: { error, alert in
            if let error = error {
                if let message = error["message"] as? String {
                    print(message)
                    print("不明なエラーが発生しました")
                } else {
                    print("不明なエラーが発生しました")
                }
                return
            }
            
            if !(alert?.isEmpty)! {
                let tmp_alert = alert![0]
                self.shabon_Alert(message: tmp_alert, callback: { locateId in
                    if let locateId = locateId {
                        //遷移
                        self.performSegue(withIdentifier: "toDetailShabonViewController", sender: locateId)
                    }else{
                        self.viewDidAppear(true)
                    }
                })
            }
        })
    }
    func closer_alert(){
        ShabonAlert.closeAlert(callback: { error, alert in
            if let error = error {
                if let message = error["message"] as? String {
                    print(message)
                    print("不明なエラーが発生しました")
                } else {
                    print("不明なエラーが発生しました")
                }
                return
            }
            if !(alert?.isEmpty)! {
                let tmp_alert = alert![0]
                self.closeAlert(message: tmp_alert, callback: { locateId in
                    if let locateId = locateId {
                        print(locateId)
                        //遷移
                        self.performSegue(withIdentifier: "toCloserDetailSegue", sender: locateId)
                    }else{
                        self.viewDidAppear(true)
                    }
                })
            }
        })
    }
    
}
    
    


