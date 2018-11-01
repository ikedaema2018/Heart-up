//
//  ProfileImageViewController.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/09/09.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit
import AWSCore

class ProfileImageViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    var errorView: UIView?
    
    // カメラまたは写真から画像を選択したか？
    private var imageSelected = false
    
    /// カメラボタンがタップされた.
    @IBAction func onTapCamera(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) == false {
            self.showAlert(message: "カメラは使用できません", hide: {})
            return
        }
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
    /// 写真ボタンがタップされた.
    @IBAction func onTapPhoto(_ sender: Any) {
        // アルバムが利用可能かをチェック.
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == false {
            self.showAlert(message: "アルバムは利用できません。", hide: {})
            return
        }
        
        // アルバムを起動.
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        self.present(picker, animated: true)
    }
    @IBAction func onTapPost(_ sender: Any) {
        // 入力チェック.
        if imageSelected == false {
            self.showAlert(message: "投稿する画像を選択してください。", hide: {})
            return
        }
        // 進捗表示を開始.
        self.showProgress()
        
        // APIで投稿.
        ProfileImage.postImage(image: profileImageView.image!) { [weak self] error in
            
            // 進捗表示を終了.
            self?.hideProgress()
            
            if let error = error {
                if let message = error["message"] as? String {
                    if message == "ユーザー情報がおかしい" {
                        self?.logoutWithError()
                        return
                    }else{
                        print("電波がおかしいとき")
                        self?.errorViewDisplay(message)
                        return
                    }
                } else {
                    print("不明なエラーが発生しました")
                }
                self?.errorViewDisplay("不明なエラーが発生しました")
                return
            } else {
                return
            }
            
            // 投稿完了を通知.
            self?.showAlert(message: "投稿しました。", hide: {})
            
            // タイムラインを表示.
            self?.navigationController?.tabBarController?.selectedIndex = 0
        }
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

extension ProfileImageViewController: UINavigationControllerDelegate {}

// カメラor写真で画像が選択された時などの処理を実装する.
extension ProfileImageViewController: UIImagePickerControllerDelegate {
    
    // カメラor写真で画像が選択された
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // UIImagePickerControllerを閉じる.
        picker.dismiss(animated: true, completion: nil)
        
        // ユーザーがカメラで撮影した or 写真から選んだ、画像がある場合.
        if var image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            // このアプリでは勝手に正方形にトリミングしちゃう.
            image = self.cropToRect(image: image)
            // 画面に表示.
            self.profileImageView.image = image
            // 設定済みをマーク.
            self.imageSelected = true
        }
    }
    
    // 画像を勝手に、上下中央で正方形にトリミングする.
    fileprivate func cropToRect(image: UIImage) -> UIImage {
        
        var image = image
        
        // 天地の調整.
        UIGraphicsBeginImageContext(image.size)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        let _image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let __image = _image {
            image = __image
        }
        
        // 正方形にする処理.
        if image.size.width != image.size.height {
            var x: CGFloat = 0, y: CGFloat = 0, w = image.size.width, h = image.size.height
            if w > h { // landscape.
                x = (w - h) / 2
                w = h
            } else {  // portrait.
                y = (h - w) / 2
                h = w
            }
            let rect = CGRect(x: x, y: y, width: w, height: h)
            let ref = image.cgImage?.cropping(to: rect)
            image = UIImage(cgImage: ref!)
        }
        
        // サイズの調整.
        let newSize = CGSize(width: 720, height: 720)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

extension ProfileImageViewController {
    //電波が悪い時に避難用のエラービューを表示
    func errorViewDisplay(_ message: String){
        errorView = UIView()
        errorView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        errorView!.backgroundColor = UIColor.white
        
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
        
        errorView!.addSubview(errorLabel)
        errorView!.addSubview(reload)
        self.view.addSubview(errorView!)
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
