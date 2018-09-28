//
//  selectUserViewController.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/09/17.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit

class selectUserViewController: UIViewController {
    var userId: String?
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var selfIntroduce: UITextView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.image = UIImage(named: "noel")
        selfIntroduce.layer.borderWidth = 1.0
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

extension selectUserViewController {
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
            
            self.userName.text = user["user_name"].string
            self.email.text = user["email"].string
            if let age = user["age"].int {
                self.age.text = String(age)
            }
            self.gender.text = user["gender"].string
            self.selfIntroduce.text = user["self_introduce"].string
            
            //画像が投稿されていたら
            if user["profile_image"] != nil {
                let image_path = user["profile_image"].string
//                let url = "http://localhost:3000/profile_image/" + image_path!
                let url = "http://s3-ap-northeast-1.amazonaws.com/heartup/images/" + image_path!
                
                self.profileImage.downloadedFrom(link: url)
            }
        }
    }
}

