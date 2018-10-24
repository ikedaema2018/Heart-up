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
    var postFlag: Bool = false
    
    @IBOutlet weak var nayamiInput: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var selectedColor: UISegmentedControl!
    @IBOutlet weak var shabonImage: UIImageView!
    @IBOutlet weak var shabonText: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var colorHelpOutret: UIButton!
    var colorHelpView: UIView!
    var colorHelpLabel: UILabel!
    var errorView: UIView!
    
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

    @IBAction func colorHelp(_ sender: Any) {
        colorHelpOutret.setTitleColor(UIColor.green, for: .normal)
        colorHelpView = UIView.init(frame: CGRect.init(x: 0, y: self.view.frame.height / 3, width: self.view.frame.width / 3, height: self.view.frame.height / 6))
        colorHelpView.center.x = colorHelpOutret.center.x
        colorHelpView.layer.borderWidth = 1
        colorHelpView.backgroundColor = UIColor.white
        
        colorHelpOutret.setTitleColor(UIColor.green, for: .normal)
        colorHelpLabel = UILabel()
        colorHelpLabel.frame = CGRect(x: 0, y: (self.view.frame.height / 3) + 10, width: self.view.frame.width / 3 - 20, height: self.view.frame.height / 7)
        colorHelpLabel.center.x = colorHelpOutret.center.x
//        colorHelpLabel.layer.borderWidth = 1
        colorHelpLabel.backgroundColor = UIColor.white
        colorHelpLabel.numberOfLines = 5
        colorHelpLabel.font = UIFont(name: "Arial", size: 10)
        //        colorHelpLabel.sizeToFit()
        colorHelpLabel.text = "恋愛系の悩みは赤 \n人間関係の悩みは青 \nその他は黄色 \n \nを使ってね"
        self.view.addSubview(colorHelpView)
        self.view.addSubview(colorHelpLabel)
        
    }
    
    let thinBlue = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    @IBAction func colorHelpExit(_ sender: Any) {
        colorHelpView.removeFromSuperview()
        colorHelpLabel.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorHelpOutret.setTitleColor(thinBlue, for: .normal)
        
        animator = UIViewPropertyAnimator(duration:1.2, curve: .easeInOut){
            self.shabonImage.center.y -= 400//これでクマの画像は下に
            self.shabonText.center.y -= 400
            self.shabonImage.alpha = 0.0
            self.shabonText.alpha = 0.0
        }
        
        let upShabon = UISwipeGestureRecognizer(target: self, action: #selector(ShabonPostViewController.shabonImageSwiped(_:)))
        upShabon.direction = .up
        view.addGestureRecognizer(upShabon)
        
        getLocate()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // キーボードイベントの監視開始
        NotificationCenter.default.addObserver(self,
            selector: #selector(keyboardWillBeShown(notification:)),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil)
        NotificationCenter.default.addObserver(self,
            selector: #selector(keyboardWillBeHidden(notification:)),
            name: NSNotification.Name.UIKeyboardWillHide,
            object: nil)
        
        if latitude == nil || longitude == nil {
            errorViewDisplay("電波の状況が悪いです")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // キーボードイベントの監視解除
        NotificationCenter.default.removeObserver(self,
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil)
        NotificationCenter.default.removeObserver(self,
            name: NSNotification.Name.UIKeyboardWillHide,
            object: nil)
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
        
        
    }
}

extension ShabonPostViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        shabonText.text = nayamiInput.text
        return true
    }
    // キーボードが表示された時に呼ばれる
    @objc func keyboardWillBeShown(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue, let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue {
                restoreScrollViewSize()
                
                let convertedKeyboardFrame = scrollView.convert(keyboardFrame, from: nil)
                // 現在選択中のTextFieldの下部Y座標とキーボードの高さから、スクロール量を決定
                let offsetY: CGFloat = self.nayamiInput!.frame.maxY - convertedKeyboardFrame.minY
                if offsetY < 0 { return }
                updateScrollViewSize(moveSize: offsetY, duration: animationDuration)
            }
        }
    }
        // moveSize分Y方向にスクロールさせる
        func updateScrollViewSize(moveSize: CGFloat, duration: TimeInterval) {
            UIView.beginAnimations("ResizeForKeyboard", context: nil)
            UIView.setAnimationDuration(duration)
            
            let contentInsets = UIEdgeInsetsMake(0, 0, moveSize, 0)
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
            self.scrollView.contentOffset = CGPoint(x: 0, y: moveSize)
            
            UIView.commitAnimations()
        }
        
        func restoreScrollViewSize() {
            // キーボードが閉じられた時に、スクロールした分を戻す
            self.scrollView.contentInset = UIEdgeInsets.zero
            self.scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
        }
    
    // キーボードが閉じられた時に呼ばれる
    @objc func keyboardWillBeHidden(notification: NSNotification) {
        restoreScrollViewSize()
    }
    
}

extension ShabonPostViewController {
    func postNayami(){
        print("huhhuhhuhuh")
        //この関数が実行されたらpostFlagをtrueに変更,trueの間はこの関数は再度実行されない
        if postFlag { return }
        postFlag = true
        //悩みを色を表示
        let segmentIndex = selectedColor.selectedSegmentIndex
        let shabonColor = selectedColor.titleForSegment(at: segmentIndex)
        
        guard let color = shabonColor else {
            errorLabel.isHidden = false
            errorLabel.text = "色を選択してね！"
            postFlag = false
            return
        }
        
        //悩みが入力されていなかったら弾く
        guard let nayamiText = nayamiInput.text else {
            errorLabel.isHidden = false
            errorLabel.text = "悩みを入力してね！"
            postFlag = false
            return
        }
        if nayamiText == "" {
            errorLabel.isHidden = false
            errorLabel.text = "悩みを入力してね！"
            postFlag = false
            return
        }
        //nayamiTextの長さが3０文字以上だったら弾く
        if nayamiText.count >= 30 {
            errorLabel.isHidden = false
            errorLabel.text = "悩みは30文字以内にしてね！"
            postFlag = false
            return
        }
        
        //緯度と経度をアンラップ
        guard let ido = latitude, let keido = longitude else {
            errorLabel.isHidden = false
            errorLabel.text = "緯度と経度が取得できないよ！"
            postFlag = false
            return
        }
        
        let nayamiLocate = LocateInfo(nayami: nayamiText, ido: ido, keido: keido, color: color)
        StockLocateInfos.postLocate(locate: nayamiLocate) { error in
            if let error = error {
                if let message = error["message"] as? String {
                    self.errorViewDisplay(message)
                }
                self.errorViewDisplay("電波が悪い可能性があります。再読み込みしてください")
            }
            //シャボン玉を飛ばすアニメーション
            self.animator.startAnimation()
            //OKを押したらshowLocateへページ遷移
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.2) {
                self.showAlert(message: "投稿しました", hide: {() -> Void in
                self.navigationController?.popViewController(animated: true)
                    
                })
            }
        }
    }
    
    func getLocate(){
        //        if locationManager != nil { return }
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
    }
    
    //電波が悪い時に避難用のエラービューを表示
    func errorViewDisplay(_ message: String){
        errorView = UIView()
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
        reload.addTarget(self, action: #selector(self.reloadView), for: .touchDown)
        
        errorView.addSubview(errorLabel)
        errorView.addSubview(reload)
        self.view.addSubview(errorView)
    }
    
    @objc func reloadView(){
        super.loadView()
        loadView()
        self.viewDidLoad()
        self.viewWillAppear(true)
        self.viewWillLayoutSubviews()
        self.viewDidLayoutSubviews()
        self.viewDidAppear(true)
    }
}
