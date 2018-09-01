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
        
        mapView.delegate = self
        // tracking user location
        mapView.userTrackingMode = MKUserTrackingMode.followWithHeading
        mapView.showsUserLocation = true
        
        // Do any additional setup after loading the view.
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
                if let ido_s = locate["ido"].string, let keido_s = locate["keido"].string, let id_i = locate["id"].int {
                    MapModule.setAnnotation(x: ido_s, y: keido_s, map: self.mapView, id: id_i)
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
                anno.image = UIImage(named: "star")
                anno.canShowCallout = true
                return anno
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let anno = view.annotation!.subtitle else {
            return
        }
        
        let anno_id = anno!
        
        
        
        
        //遷移
        performSegue(withIdentifier: "toDetailShabonViewController", sender: anno_id)
    }
    
    //ページ遷移で数値を
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailShabonViewController" {
            if let vc = segue.destination as? detailShabonViewController {
                if let id = sender as? String {
                    vc.shabon_id = id
                }
            }
        }
    }
    
    
    
    

}
