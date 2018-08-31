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
    
    
    
    @IBAction func signUp(_ sender: Any) {
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
                } else {
                    print("謎のエラー発生！")
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
        errorLabel.isHidden = true
        userNameInput.delegate = self
        emailInput.delegate = self
        passwordInput.delegate = self
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
