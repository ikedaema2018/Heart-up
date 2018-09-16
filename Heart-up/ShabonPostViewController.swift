//
//  ShabonPostViewController.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/08/31.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit
import CoreLocation

class ShabonPostViewController: UIViewController {
    var locationManager : CLLocationManager?
    var animator: UIViewPropertyAnimator!
    
    @IBOutlet weak var nayamiInput: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var selectedColor: UISegmentedControl!
    @IBOutlet weak var shabonImage: UIImageView!
    @IBOutlet weak var shabonText: UILabel!
    
    
    
    @IBAction func tmp_button(_ sender: Any) {
        animator.startAnimation()
    }
    
    
    //常に更新される緯度経度を定義
    var latitude :String?
    var longitude :String?
    
    @IBAction func nayamiSubmit(_ sender: Any) {
        postNayami()
    }
    
    @objc func shabonImageSwiped(_ sender: UISwipeGestureRecognizer) {
        postNayami()
    }
    
    @IBAction func shabonColorSegment(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            shabonImage.image = UIImage(named: "redShabon")
        case 1:
            shabonImage.image = UIImage(named: "blueShabon")
        case 2:
            shabonImage.image = UIImage(named: "yellowShabon")
        default:
            print("エラー")
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animator = UIViewPropertyAnimator(duration:1.2,curve: .easeInOut){
            self.shabonImage.center.y -= 400//これでクマの画像は下に
            self.shabonText.center.y -= 400
            self.shabonImage.alpha = 0.0
            self.shabonText.alpha = 0.0
        }
        
        let upShabon = UISwipeGestureRecognizer(target: self, action: #selector(ShabonPostViewController.shabonImageSwiped(_:)))
        upShabon.direction = .up
        view.addGestureRecognizer(upShabon)
        
        
        if locationManager != nil { return }
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        nayamiInput.placeholder = "悩みを入力してね"
        submitButton.layer.cornerRadius = 2.0
        locationManager!.requestWhenInUseAuthorization()
        errorLabel.isHidden = true
        nayamiInput.delegate = self
        
        shabonImage.image = UIImage(named: "redShabon")
    
        if CLLocationManager.locationServicesEnabled() {
            locationManager!.startUpdatingLocation()
        }
        
        locationManager!.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager!.distanceFilter = 1000

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ShabonPostViewController: CLLocationManagerDelegate {
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

extension ShabonPostViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        shabonText.text = nayamiInput.text
        return true
    }
}

extension ShabonPostViewController {
    func postNayami(){
        //悩みを色を表示
        let segmentIndex = selectedColor.selectedSegmentIndex
        let shabonColor = selectedColor.titleForSegment(at: segmentIndex)
        
        guard let color = shabonColor else {
            errorLabel.isHidden = false
            errorLabel.text = "色を選択してね！"
            return
        }
        
        //悩みが入力されていなかったら弾く
        guard let nayamiText = nayamiInput.text else {
            errorLabel.isHidden = false
            errorLabel.text = "悩みを入力してね！"
            return
        }
        if nayamiText == "" {
            errorLabel.isHidden = false
            errorLabel.text = "悩みを入力してね！"
            return
        }
        errorLabel.isHidden = true
        
        //緯度と経度をアンラップ
        guard let ido = latitude, let keido = longitude else {
            errorLabel.text = "緯度と経度が取得できないよ！"
            return
        }
        
        
        
        let nayamiLocate = LocateInfo(nayami: nayamiText, ido: ido, keido: keido, color: color)
        StockLocateInfos.postLocate(locate: nayamiLocate) { error in
            if let error = error {
                if let message = error["message"] as? String {
                    self.showAlert(message: message, hide: {})
                } else {
                    self.showAlert(message: "エラーが発生しました", hide: {})
                }
                return
            }
            //シャボン玉を飛ばすアニメーション
            self.animator.startAnimation()
            //OKを押したらshowLocateへページ遷移
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.2) {
                self.showAlert(message: "投稿しました", hide: {})
            }
        }
    }
}
