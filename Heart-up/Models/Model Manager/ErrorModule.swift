//
//  ErrorModule.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/10/24.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit

class ErrorModule: NSObject {
    static let shared = ErrorModule()
    func errorCheck2(error: [String: Any]?, viewController: UIViewController) -> Void {
        if let error = error {
            if let message = error["message"] as? String {
                if message == "ユーザー情報がおかしい" {
                    viewController.logoutWithError()
                    return
                }else{
                    print("電波がおかしいとき")
                    viewController.errorViewDisplay2(message)
                    return
                }
            } else {
                print("不明なエラーが発生しました")
            }
            viewController.errorViewDisplay2("不明なエラーが発生しました")
            return
        } else {
            return
        }
    }
}

extension UIViewController {
    //電波が悪い時に避難用のエラービューを表示
    func errorViewDisplay2(_ message: String){
        var errorView = UIView()
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
        reload.addTarget(self, action: #selector(self.reloadView2), for: .touchDown)
        
        errorView.addSubview(errorLabel)
        errorView.addSubview(reload)
        self.view.addSubview(errorView)
    }
    
    @objc func reloadView2(){
        loadView()
        self.viewDidLoad()
        self.viewWillAppear(true)
        self.viewWillLayoutSubviews()
        self.viewDidLayoutSubviews()
        self.viewDidAppear(true)
    }
}
