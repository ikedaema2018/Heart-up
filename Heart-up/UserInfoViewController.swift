//
//  UserInfoViewController.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/09/19.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit
import CoreLocation

class UserInfoViewController: UIViewController {
    var userId: String?
    var place = ""
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var selfIntroduce: UITextView!
    @IBOutlet weak var locateLabel: UILabel!
    var errorView: UIView!
    
    
    
    @IBAction func tapView(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("aaaaa")
        profileImage.image = UIImage(named: "myPage")
        selfIntroduce.layer.borderWidth = 1.0
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("bbbbb")
        fetchData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension UserInfoViewController {
    func fetchData(){
        StockLocateInfos.getSelectUser(userId: userId!){ error, result in
            print("ccccc")
            if let error = error {
                print("ddddd")
                if let message = error["message"] as? String {
                    print(message)
                    self.errorViewDisplay(message)
                } else {
                    self.errorViewDisplay("不明なエラーが発生しました")
                }
                self.errorViewDisplay("インターネットに接続されていません")
            }
            
            guard let user = result else {
                return
            }
            
            guard let user_id = UserDefaults.standard.string(forKey: "user_id") else {
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    appDelegate.showLoginStoryboard()
                }
                return
            }
            
            if self.userId! == user_id {
                self.userName.text = "わたし"
            }else{
                self.userName.text = user["user_name"].string
            }
            if let age = user["age"].int {
                self.age.text = "\(String(age))歳"
            }
            
            self.gender.text = user["gender"].string
            self.selfIntroduce.text = user["self_introduce"].string
            
            //画像が投稿されていたら
            if user["profile_image"] != nil {
                let image_path =
                    user["profile_image"].string
                let url = "http://s3-ap-northeast-1.amazonaws.com/heartup/images/" + image_path!
                self.profileImage.downloadedFrom(link: url)
            }
            //リバースジオロケートで緯度経度
            let geocoder = CLGeocoder()
            let location = CLLocation(latitude: user["user_locate"]["ido"].double!, longitude: user["user_locate"]["keido"].double!)
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let error = error {
                    self.errorViewDisplay("インターネットに接続されていません")
                }
                
                if let placemarks = placemarks {
                    if let pm = placemarks.first {
                        //placeを初期化
                        self.place = ""
                        self.place += pm.administrativeArea ?? ""
                        self.place += pm.locality ?? ""
                        self.place += pm.subLocality ?? ""
                        self.locateLabel.text = self.place
                        self.locateLabel.font = UIFont.systemFont(ofSize: 14)
                    }
                }
                
            }
        }
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
