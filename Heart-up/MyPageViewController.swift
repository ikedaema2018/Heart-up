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
    
    @IBAction func saveButton(_ sender: Any) {
        UserRegister.updateIntroduce(intro: selfIntroduceView.text, callback: { error in
            if let error = error {
                if let message = error["message"] {
                    print(message)
                    print("不明なエラーが発生しました")
                    self.showAlert(message: "自己紹介の変更ができなかったよ！", hide: { () -> Void in
                        self.dismiss(animated: true, completion: nil)
                    })
                } else {
                    print("謎のエラー発生！")
                    self.showAlert(message: "自己紹介の変更ができなかったよ！", hide: { () -> Void in
                        self.dismiss(animated: true, completion: nil)
                    })
                }
                return
            }
            
            self.showAlert(message: "自己紹介の変更に成功したよ！", hide: { () -> Void in
                self.dismiss(animated: true, completion: nil)
            })
        })
    }
    
    //ログアウトボタン
    @IBAction func loguotButton(_ sender: Any) {
        logOutAlert()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        selfIntroduceView.delegate = self
        profileImage.image = UIImage(named: "myPage")
        
        selfIntroduceView.layer.borderWidth = 1.0
//        selfIntroduceView.isEditable = false

        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.handleKeyboardWillShowNotification(_:)), name: .UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(self.handleKeyboardWillHideNotification(_:)), name: .UIKeyboardWillHide, object: nil)
        fetchData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeObserver()
    }
}

extension MyPageViewController {
    func fetchData(){
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
            

            self.userName.text = user["user_name"].string
            self.mailAddress.text = user["email"].string
            if let age = user["age"].int {
                self.ageLabel.text = String(age)
            }
            self.genderLabel.text = user["gender"].string
            self.selfIntroduceView.text = user["self_introduce"].string
    
            //画像が投稿されていたら
            if user["profile_image"] != nil {
                let image_path = user["profile_image"].string
                let url = "http://s3-ap-northeast-1.amazonaws.com/heartup/images/" + image_path!
//                let url = "http://localhost:3000/profile_image/" + image_path!

                self.profileImage.downloadedFrom(link: url)
            }
        }
    }
}

extension MyPageViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if (text == "\n") {
            //あなたのテキストフィールド
            selfIntroduceView.resignFirstResponder()
            return false
        }
        return true
    }
    
    // キーボードが現れた時に、画面全体をずらす。
    @objc private func handleKeyboardWillShowNotification(_ notification: Notification) {
        let userInfo = notification.userInfo //この中にキーボードの情報がある
        let keyboardSize = (userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardY = self.view.frame.size.height - keyboardSize.height //画面全体の高さ - キーボードの高さ = キーボードが被らない高さ
        let editingTextFieldY: CGFloat = (self.selfIntroduceView?.frame.origin.y)!
        if editingTextFieldY > keyboardY - 60 {
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
                self.view.frame = CGRect(x: 0, y: self.view.frame.origin.y - (editingTextFieldY - (keyboardY - 60)), width: self.view.bounds.width, height: self.view.bounds.height)
            }, completion: nil)
        }
    }
    
    // キーボードが消えたときに、画面を戻す
    @objc private func handleKeyboardWillHideNotification(_ notification: Notification) {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        }, completion: nil)
    }
}

extension MyPageViewController {
    // Notificationを削除
    func removeObserver() {
        let notification = NotificationCenter.default
        notification.removeObserver(self)
    }
    //ログアウト用
    func logOutAlert(){
        let alert = UIAlertController(title: "", message: "ログアウトしますか？", preferredStyle: .alert)
        
        let logoutAction = UIAlertAction(title: "はい", style: .default) { action in
            UserDefaults.standard.removeObject(forKey: "user_id")
            UserDefaults.standard.removeObject(forKey: "auth_token")
            alert.dismiss(animated: true, completion: nil)
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.showLoginStoryboard()
            }
        }
        alert.addAction(logoutAction)
        
        let cancelAction = UIAlertAction(title: "いいえ", style: .cancel)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
}
