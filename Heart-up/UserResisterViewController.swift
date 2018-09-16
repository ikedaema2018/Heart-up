//
//  UserResisterViewController.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/08/31.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit


class UserResisterViewController: UIViewController {
    @IBOutlet weak var userNameInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var agePicker: UIPickerView!
    var age: String = ""
    
    var ageList: [Int] = []
    
    let genderArray: [String] = ["男","女"]
    
    @IBOutlet weak var genderSegment: UISegmentedControl!
    
    
    @IBOutlet weak var selfIntroduce: UITextView!
    
    
    @IBAction func signUp(_ sender: Any) {
        guard let user_name = userNameInput.text, let email = emailInput.text, let password = passwordInput.text, let self_introduce = selfIntroduce.text else {
            errorLabel.isHidden = false
            errorLabel.text = "ユーザーネームとメールアドレスとパスワードと自己紹介は必ず入力してください"
            return
        }
        
        if user_name.isEmpty || email.isEmpty || password.isEmpty || age.isEmpty || self_introduce.isEmpty {
            errorLabel.isHidden = false
            errorLabel.text = "ユーザーネームとメールアドレスとパスワードと自己紹介は必ず入力してください"
            return
        }
        
        let user: [String: String] = ["email": email, "user_name": user_name, "password": password, "age": age, "gender": genderArray[genderSegment.selectedSegmentIndex], "self_introduce": self_introduce]
        
        print(user)
        
        //ユーザー情報をポスト
        UserRegister.postLocate(user: user, callback: { data, error in
            if let error = error {
                if let message = error["message"] {
                    print(message)
                    print("不明なエラーが発生しました")
                    self.errorLabel.text = "不明なエラーが発生しました"
                } else {
                    print("謎のエラー発生！")
                    self.errorLabel.text = "謎のエラー発生！"
                }
                return
            }
            guard let data = data else {
                return
            }
            print(data)
            print("ユーザー登録成功！")
            self.showAlert(message: "ユーザー登録成功したよ！\nログインしてね", hide: { () -> Void in
                    self.dismiss(animated: true, completion: nil)
                })
        })
    }
    

    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 10...100 {
            ageList += [i]
        }
        
        errorLabel.isHidden = true
        userNameInput.delegate = self
        emailInput.delegate = self
        passwordInput.delegate = self
        
        agePicker.delegate = self
        agePicker.dataSource = self
        
        selfIntroduce.delegate = self
        selfIntroduce.layer.borderWidth = 1.0
        
        
        //placeholderを指定
        userNameInput.placeholder = "ユーザーネーム"
        emailInput.placeholder = "メールアドレス"
        passwordInput.placeholder = "パスワード"
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
}

extension UserResisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension UserResisterViewController: UIPickerViewDataSource, UIPickerViewDelegate {


    //Picerviewの列の数は1とする
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //PickerViewに表示する配列の要素数を設定する
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ageList.count
    }
    
    //表示する文字列を指定する
    func pickerView(_ pickerview: UIPickerView, titleForRow row: Int, forComponent component: Int)-> String? {
        return "\(String(ageList[row]))歳"
    }
    
    //選択された時
    func pickerView(_ pickerview: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        age = String(ageList[row])
    }

}

extension UserResisterViewController: UITextViewDelegate {
    // hides text views
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if (text == "\n") {
            //あなたのテキストフィールド
            selfIntroduce.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.layer.borderColor = UIColor.red.cgColor
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.layer.borderColor = UIColor.black.cgColor
    }
    
    // キーボードが表示された時に呼ばれる
    @objc func keyboardWillBeShown(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue, let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue {
                restoreScrollViewSize()
                
                let convertedKeyboardFrame = scrollView.convert(keyboardFrame, from: nil)
                // 現在選択中のTextFieldの下部Y座標とキーボードの高さから、スクロール量を決定
                print(self.selfIntroduce!.frame.maxY)
                print(convertedKeyboardFrame.minY)
                let offsetY: CGFloat = self.selfIntroduce!.frame.maxY - convertedKeyboardFrame.minY
                if offsetY < 0 { return }
                updateScrollViewSize(moveSize: offsetY + 300, duration: animationDuration)
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

extension UserResisterViewController {
    
    
    // Notificationを削除
    func removeObserver() {
        
        let notification = NotificationCenter.default
        notification.removeObserver(self)
    }
}
