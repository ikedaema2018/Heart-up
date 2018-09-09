//
//  ShowLocateViewController.swift
//  
//
//  Created by 前田啓 on 2018/08/24.
//

import UIKit
import MapKit


class ShowLocateViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UserDefaltsを初期化したい時
//        let userDefaults = UserDefaults.standard
//        userDefaults.removeObject(forKey: "auth_token")
//        userDefaults.removeObject(forKey: "user_id")
        
        
        mapView.delegate = self
        // tracking user location
        mapView.userTrackingMode = MKUserTrackingMode.followWithHeading
        mapView.showsUserLocation = true
        
        fetchData()
        
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
                if let color = (( annotation as! CustomAnnotation ).data["color"]) {
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
        
        //subTitleの文字列の加工
        guard let locate_id = view.annotation!.subtitle! else {
            return
        }
        
        let locate_id_str = String(locate_id[..<locate_id.index(locate_id.startIndex, offsetBy: 1)])
        
        
        //遷移
        performSegue(withIdentifier: "toDetailShabonViewController", sender: locate_id_str)
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
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view.
        
        //一旦ピン削除
        removeAllAnnotations()
        fetchData()
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
                if let ido_s = locate["ido"].string, let keido_s = locate["keido"].string, let id_i = locate["id"].int, let nayami = locate["nayami"].string, let user_id = locate["user_id"].int, let color = locate["color"].string, let user_name = locate["user"]["user_name"].string {
                    MapModule.setAnnotation(x: ido_s, y: keido_s, map: self.mapView, id: id_i, nayami: nayami, user_id: user_id, user_name: user_name, color: color)
                }
            }
            
            //ピンを立てる
            //            if let locates = locates {
            //                if let ido_s = locates["ido"] as? String, let keido_s = locates["keido"] as? String {
            //                    MapModule.setAnnotation(x: ido_s, y: keido_s, map: self.mapView)
            //                }
            //            }
        }
    }
    
    func removeAllAnnotations() {
        let annotations = mapView.annotations.filter {
            $0 !== self.mapView.userLocation
        }
        mapView.removeAnnotations(annotations)
    }
}
    
    
    


