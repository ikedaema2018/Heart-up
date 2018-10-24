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
    var zoomLevel :Int?
    var locates: JSON?
    var users: JSON?
    
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
        
        
//        UserDefaltsを初期化したい時
//        let userDefaults = UserDefaults.standard
//        userDefaults.removeObject(forKey: "auth_token")
//        userDefaults.removeObject(forKey: "user_id")

        mapView.delegate = self
        // tracking user location
        mapView.userTrackingMode = MKUserTrackingMode.followWithHeading
        mapView.showsUserLocation = true
        //画面をロードした時に日本列島にカーソルが合わさるように
        Distance.setUpJapan(map: mapView)
        
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
                
                anno.canShowCallout = false
                
                //ズームレベルを定義
                zoomLevel = mapView.currentZoomLevel
                let zoomSize: Double = Double((zoomLevel! / 3) * (zoomLevel! / 3))
                
                //userかshabonかチェック
                if let user = annotation as? UserAnnotation {
                    guard let userImage = user.userImage!["userImage"] as? String else {
                        var myPage = UIImage(named: "myPage")
                        myPage = myPage?.resize(image: myPage!, width: zoomSize)
                        
                        anno.image = myPage
                        return anno
                    }
                    let url = URL( string: "http://s3-ap-northeast-1.amazonaws.com/heartup/images/" + userImage)
                    let data = try? Data(contentsOf: url!)
                    let theImage = UIImage(data: data!)
                    let scaledImage = theImage?.resize(image: theImage!, width: zoomSize)
                    //anno.imageにUIImageを設定する
                    anno.image = scaledImage
                    return anno
                }
                if let shabon = annotation as? CustomAnnotation {
                    let nayamiCount = Double(shabon.nayamiCount)
                    
                    let color_s = shabon.color["color"] as! String
                    if color_s  == "黄" {
                        var color = UIImage(named: "yellow")
                        color = color?.resize(image: color!, width: zoomSize + nayamiCount)
                        anno.image = color
                    } else if color_s == "青" {
                        var color = UIImage(named: "blue")
                        color = color?.resize(image: color!, width: zoomSize + nayamiCount)
                        anno.image = color
                    } else if color_s == "赤" {
                        var color = UIImage(named: "red")
                        color = color?.resize(image: color!, width: zoomSize + nayamiCount)
                        anno.image = color
                    }
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
        
        if view.annotation is CustomAnnotation {
            if let locateId = (view.annotation as! CustomAnnotation).locateId["locateId"] {
                 let locateId = locateId as! Int
                //遷移のためのハッシュ
                let sender: [String: Any] = ["locateId": locateId, "finishFlag" : false]
                performSegue(withIdentifier: "showToContents", sender: sender)
            }
        }
        
        if view.annotation is UserAnnotation {
            if let userId = (view.annotation as! UserAnnotation).userId["userId"] {
                let userId = userId as! Int
                let sender = ["userId": userId]
                //遷移
                performSegue(withIdentifier: "toSelectUserSegue", sender: sender)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        userLocation.title = ""
    }
    
    // 表示領域が変化した後に呼ばれる
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if zoomLevel != nil {
            if mapView.currentZoomLevel != zoomLevel! {
                setAnno(locates, users)
            }
        }
    }
    
    
    //ページ遷移で数値を
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sender = sender as? [String: Any] else {
            return
        }
        
        if segue.identifier == "showToContents" {
            if let vc = segue.destination as? ShabonContentsViewController {
                guard let locateId = sender["locateId"] as? Int else {
                    return
                }
                print(locateId)
                vc.id = String(locateId)
                vc.happyGraduationFlag = (sender["finishFlag"] as? Bool)!
            }
        }else if segue.identifier == "toSelectUserSegue" {
            if let vc = segue.destination as? UserInfoViewController {
                vc.userId = String(sender["userId"] as! Int)
            }    
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view.
        print("--------viewWillAppear--------")
        fetchData()
//        //画面をロードするたびに現在地をセンターに
//        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after loading the view.
        print("--------viewDidAppear--------")
        
        //shabon_alert テーブルから検索する処理
        select_user_alert()
        closer_alert()
        nayamiBadging()
    }
    
}

extension ShowLocateViewController {
    func fetchData(){
        StockLocateInfos.getLocate {error, locates in
            
            if let error = error {
                if let message = error["message"] as? String {
                    self.errorViewDisplay(message)
                    return
                } else {
                    print("不明なエラーが発生しました")
                    return
                }
                return
            }
            
            //かなり無茶苦茶な処理だけど地図の倍率が変わった時に使うため
            self.locates = locates
            
            //ここで１時間前までにアップデートしたユーザーを引っ張ってくる処理を書く
            UserLocate.currentUser {error, users in
                
                if let error = error {
                    if let message = error["message"] as? String {
                        print(message)
                        print("2")
                        self.errorViewDisplay(message)
                    } else {
                        print("不明なエラーが発生しました")
                        print("3")
                        self.errorViewDisplay("不明なエラーが発生しました")
                    }
                    return
                }
                
                //かなり無茶苦茶な処理だけど地図の倍率が変わった時に使うため
                self.users = users
                
                //アノテーションをセット
                self.setAnno(self.locates, self.users)
            }
        }
    }
    
    func setAnno(_ locates: JSON?,_ users: JSON?){
        guard let locates = locates, let users = users else {
            return
        }
        //一旦ピン削除
        removeAllAnnotations()
        //ピンを一覧で表示
        locates.forEach { (_, locate) in
            if let ido_s = locate["ido"].double, let keido_s = locate["keido"].double, let id_i = locate["id"].int, let nayami = locate["nayami"].string, let user_id = locate["user_id"].int, let color = locate["color"].string, let user_name = locate["user"]["user_name"].string {
                MapModule.setAnnotation(x: ido_s, y: keido_s, map: self.mapView, id: id_i, nayami: nayami, user_id: user_id, user_name: user_name, color: color, nayamiCount: locate["nayami_comments"].count)
            }
        }
        
        guard let userId = UserDefaults.standard.string(forKey: "user_id") else {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.showLoginStoryboard()
            }
            return
        }
        //userのピンを一覧で表示
        users.forEach { (i, user) in
            if let ido = user["ido"].double, let keido = user["keido"].double, let user_id = user["user_id"].int, let userName = user["user"]["user_name"].string {
                if user_id == Int(userId) {
                    return
                } else {
                    let userImage: String? = user["user"]["profile_image"].string
                    MapModule.setUserAnnotation(x: ido, y: keido, map: self.mapView, userId: user_id, userName: userName, userImage: userImage)
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
        
    }
}

extension ShowLocateViewController {
    func user_locate_update(ido: String, keido: String) -> Void {
        UserLocate.userLocateUpdate(ido: ido, keido: keido, callback: { response in
            if let error = response {
                let error_message = error["message"] as! String
                print(error_message)
//                self.showAlert(message: error_message, hide: {})
                //ここでエラービューを表示
                self.errorViewDisplay(error_message)
            }
        })
    }
    func select_user_alert() {
        ShabonAlert.select_user_alert(callback: { error, alert in
            if let error = error {
                if let message = error["message"] as? String {
                    print(message)
                    self.errorViewDisplay(message)
                } else {
                    print("不明なエラーが発生しました")
                    self.errorViewDisplay("不明なエラーが発生しました。")
                }
                
                return
            }
            
            if !(alert?.isEmpty)! {
                let tmp_alert = alert![0]
                self.shabon_Alert(message: tmp_alert, callback: { locateId in
                    if let locateId = locateId {
                        //遷移のためのハッシュ
                        let sender: [String: Any] = [ "locateId": locateId, "finishFlag" : true]
                    self.performSegue(withIdentifier: "showToContents", sender: sender)
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
                    self.errorViewDisplay(message)
                } else {
                    print("不明なエラーが発生しました")
                    self.errorViewDisplay("不明なエラーが発生しました")
                }
                return
            }
            if !(alert?.isEmpty)! {
                let tmp_alert = alert![0]
                self.closeAlert(message: tmp_alert, callback: { locateId in
                    if let locateId = locateId {
                        //遷移のためのハッシュ
                        let sender: [String: Any] = [ "locateId": Int(locateId), "finishFlag" : false]
                        //遷移
                        self.performSegue(withIdentifier: "showToContents", sender: sender)
                    }else{
                        self.viewDidAppear(true)
                    }
                })
            }
        })
    }
    
    func nayamiBadging(){
        NayamiComment.myShabonNayamiFind(callback: { error, result in
            if let error = error {
                if let message = error["message"] as? String {
                    print(message)
                    self.errorViewDisplay(message)
                } else {
                    print("不明なエラーが発生しました")
                    self.errorViewDisplay("不明なエラーが発生しました")
                }
                return
            }
            if let yondenaiComments = result {
                if yondenaiComments.count > 0 {
                    self.tabBarController?.tabBar.items![1].badgeValue = String(yondenaiComments.count)
                } else {
                    self.tabBarController?.tabBar.items![1].badgeValue = nil
                }
            }
        })
    }
    
    //電波が悪い時に避難用のエラービューを表示
    func errorViewDisplay(_ message: String){
        var errorView = UIView()
        errorView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        errorView.backgroundColor = UIColor.white
        
        let errorLabel = UILabel()
        let grayColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        errorLabel.text = message
        errorLabel.textColor = grayColor
        errorLabel.font = UIFont(name: "Arial", size: 20)
        errorLabel.frame = CGRect(x: 20, y: 100, width: self.view.frame.width - 40, height: 60)
        errorLabel.numberOfLines = 3
        
        let reload = UIButton()
        reload.setTitle("再読み込みする", for: .normal)
        let thinBlue = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        reload.backgroundColor = thinBlue
        reload.layer.cornerRadius = 10
        
        reload.frame = CGRect(x: 0, y: 0, width: self.view.frame.width / 3, height: 50)
        reload.center = self.view.center
        
        errorView.addSubview(errorLabel)
        errorView.addSubview(reload)
        self.view.addSubview(errorView)
    }
    
}

extension UIImage {
    
    func scaledImage(withSize size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    
    func scaleImageToFitSize(size: CGSize) -> UIImage {
        let aspect = self.size.width / self.size.height
        if size.width / aspect <= size.height {
            return scaledImage(withSize: CGSize(width: size.width, height: size.width / aspect))
        } else {
            return scaledImage(withSize: CGSize(width: size.height * aspect, height: size.height))
        }
    }
    
}
    


