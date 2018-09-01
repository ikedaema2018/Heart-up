//
//  LoginViewController.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/08/30.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginEmailInput: UITextField!
    @IBOutlet weak var loginPasswordInput: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loginEmailInput.delegate = self
        loginPasswordInput.delegate = self
        self.showAlert(message: "ログインしてね！", hide: {})
        
        //プレースホルダーを指定
        loginEmailInput.placeholder = "メールアドレス"
        loginPasswordInput.placeholder = "パスワード"
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTapLogin(_ sender: Any) {
        guard let loginEmail = loginEmailInput.text, let loginPassword = loginPasswordInput.text else {
            errorLabel.isHidden = false
            errorLabel.text = "メールアドレスとパスワードは必ず入力してください"
            return
        }
        
        if loginEmail.isEmpty || loginPassword.isEmpty {
            errorLabel.isHidden = false
            errorLabel.text = "メールアドレスとパスワードは必ず入力してください"
            return
        }
        
        //エラー表示を非表示
        errorLabel.isHidden = true
        
        ApiManager.shared.login(loginEmail: loginEmail, loginPassword: loginPassword) { errorInfo in
            
            //エラー表示
            if errorInfo != nil {
                self.errorLabel.isHidden = false
                self.errorLabel.text = "ログイン失敗"
                return
            }
            
            //成功したよ
            //ここにアラート
            self.showAlert(message: "ログイン成功したよ！", hide: {})
            
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.showMainStoryboard()
            }
        }
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

extension LoginViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
