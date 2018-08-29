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
        
        mapView.delegate = self
        
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
                
                if let ido_s = locate["ido"].string, let keido_s = locate["keido"].string {
                    MapModule.setAnnotation(x: ido_s, y: keido_s, map: self.mapView)
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
        //遷移
        performSegue(withIdentifier: "toDetailShabonViewController", sender: nil)
    }
    
    

}
