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
        ProfileImage.postImage(image: profileImageView.image!) { [weak self] errorInfo in
            
            // 進捗表示を終了.
            self?.hideProgress()
            
            // エラー処理.
            if let errorInfo = errorInfo {
                if let message = errorInfo["message"] as? String {
                    self?.showAlert(message: message, hide: {})
                } else {
                    self?.showAlert(message: "エラーが発生しました。", hide: {})
                }
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
//    fileprivate func configureService() {
//        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: "your access key", secretKey: "your secret key")
//        let serviceConfiguration = AWSServiceConfiguration(region: AWSRegionType.apNortheast1, credentialsProvider: credentialsProvider)
//        AWSServiceManager.default().defaultServiceConfiguration = serviceConfiguration
//    }
}
