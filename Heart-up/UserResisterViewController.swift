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
    
    @IBOutlet weak var agePicker: UIPickerView!
    var age: Int?
    
    var ageList: [Int] = []
    
    let genderArray: [String] = ["男","女"]
    
    @IBOutlet weak var genderSegment: UISegmentedControl!
    
    
    @IBOutlet weak var selfIntroduce: UITextView!
    
    
    @IBAction func signUp(_ sender: Any) {
        print(genderArray[genderSegment.selectedSegmentIndex])
        guard let user_name = userNameInput.text, let email = emailInput.text, let password = passwordInput.text else {
            errorLabel.isHidden = false
            errorLabel.text = "ユーザーネームとメールアドレスとパスワードは必ず入力してください"
            return
        }
        
        if user_name.isEmpty || email.isEmpty || password.isEmpty {
            errorLabel.isHidden = false
            errorLabel.text = "ユーザーネームとメールアドレスとパスワードは必ず入力してください"
            return
        }
        
        let user: [String: String] = ["email": email, "user_name": user_name, "password": password]
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
        let age = ageList[row]
    }

}

extension UserResisterViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.layer.borderColor = UIColor.red.cgColor
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.layer.borderColor = UIColor.black.cgColor
    }
    
    // hides text views
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if (text == "\n") {
            //あなたのテキストフィールド
            textView.resignFirstResponder()
            print(selfIntroduce.text)
            return false
        }
        return true
    }
}
