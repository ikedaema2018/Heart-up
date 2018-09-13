//
//  Ext.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/08/30.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation

extension UIViewController {
    func showAlert(message: String, hide: @escaping () -> Void) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
            hide()
        })
        self.present(alert, animated: true)
    }
    
    func shabon_Alert(message: JSON, callback: @escaping (String?) -> Void) {
        //ロケート情報を定義
        var locate: JSON?
        
        guard let id = message["locate_info"]["id"].int else {
            return
        }
        //locateIdで緯度経度を取得してくる
        StockLocateInfos.getDetailLocation(id: String(id)) { error, tmp_locate in
            if let error = error {
                if let message = error["message"] as? String {
                    print(message)
                    print("不明なエラーが発生しました")
                } else {
                    print("不明なエラーが発生しました")
                }
                return
            }
            locate = tmp_locate
            guard let longitude = locate!["keido"].string, let latitude = locate!["ido"].string else {
                return
            }
            //リバースジオロケートで緯度経度
            let geocoder = CLGeocoder()
            let location = CLLocation(latitude: Double(latitude)!, longitude: Double(longitude)!)
            var place = ""
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let placemarks = placemarks {
                    if let pm = placemarks.first {
                        place += pm.administrativeArea ?? ""
                        place += pm.locality ?? ""
                    }
                }
                let alert = UIAlertController(title: "あなたのシャボン玉が\(place)で破裂しました", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "見に行く", style: .default) { action in
                    alert.dismiss(animated: true, completion: nil)
                    // APIで投稿.
                    ShabonAlert.fixAlert(id: message["id"].int!) { errorInfo in
                        
                        // エラー処理.
                        if let errorInfo = errorInfo {
                            if let message = errorInfo["message"] as? String {
                                self.showAlert(message: message, hide: {})
                            } else {
                                self.showAlert(message: "エラーが発生しました。", hide: {})
                            }
                            return
                        }
                        
                        guard let locateId = message["locate_info_id"].int else {
                            return
                        }
                        callback(String(locateId))
                    }
                })
                // 「キャンセル」ボタンを設置.
                let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { action in
                    // APIで投稿.
                    ShabonAlert.fixAlert(id: message["id"].int!) { errorInfo in
                        
                        // エラー処理.
                        if let errorInfo = errorInfo {
                            if let message = errorInfo["message"] as? String {
                                self.showAlert(message: message, hide: {})
                            } else {
                                self.showAlert(message: "エラーが発生しました。", hide: {})
                            }
                            return
                        }
                        callback(nil)
                    }
                }
                alert.addAction(cancelAction)
                
                self.present(alert, animated: true)
            }
            
            
        }
    }
    
    func showProgress() {
        let indicator = UIActivityIndicatorView()
        indicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        indicator.center = self.view.center
        indicator.tag = 837192
        self.view.addSubview(indicator)
        indicator.startAnimating()
    }
    
    func hideProgress() {
        if let indicator = self.view.viewWithTag(837192) {
            indicator.removeFromSuperview()
        }
    }
}

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
