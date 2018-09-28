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
    
    
    
    @IBAction func tapView(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.image = UIImage(named: "noel")
        selfIntroduce.layer.borderWidth = 1.0
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
            if let error = error {
                if let message = error["message"] as? String {
                    print(message)
                    print("不明なエラーが発生しました")
                } else {
                    print("不明なエラーが発生しました")
                }
                return
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
}
