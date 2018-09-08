//
//  MyPageViewController.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/09/03.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit

class MyPageViewController: UIViewController {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var mailAddress: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var selfIntroduceView: UITextView!
    @IBOutlet weak var profileImage: UIImageView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.image = UIImage(named: "noel")
        
        selfIntroduceView.layer.borderWidth = 1.0
        selfIntroduceView.isEditable = false
    
        StockLocateInfos.getMyProfile(){ error, result in
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
            print(user)
            self.userName.text = user["user_name"].string
            self.mailAddress.text = user["email"].string
            if let age = user["age"].int {
                self.ageLabel.text = String(age)
            }
            self.genderLabel.text = user["gender"].string
            self.selfIntroduceView.text = user["self_introduce"].string
            
        }
        
        // Do any additional setup after loading the view.
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
