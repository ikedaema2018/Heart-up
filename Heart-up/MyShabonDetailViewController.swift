//
//  MyShabonDetailViewController.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/09/06.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation

class MyShabonDetailViewController: UICollectionViewController {
    var id: String?
    var locates: JSON?
    //逆ジオロケのため
    var place = ""
    let headerId = "headerId"
    
    // ステータスバーの高さ
    let statusBarHeight = UIApplication.shared.statusBarFrame.height
    
    // セル再利用のための固有名
    let cellId = "itemCell"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(topHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView?.register(UINib(nibName: "MyShabonCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MyShabonCollectionViewCell")
        
        guard let shabonId = id else {
            return
        }
        
        StockLocateInfos.getDetailLocation(id: shabonId, callback: {error, locate in
            
            if let error = error {
                if let message = error["message"] as? String {
                    print(message)
                    print("不明なエラーが発生しました")
                } else {
                    print("不明なエラーが発生しました")
                }
                return
            }
            
            
            self.locates = locate
            // 画面全体に色を設定
            if self.locates!["color"].string == "赤" {
                self.view.backgroundColor = UIColor.red
            } else if self.locates!["color"].string == "青" {
                self.view.backgroundColor = UIColor.blue
            } else if self.locates!["color"].string == "黄" {
                self.view.backgroundColor = UIColor.yellow
            }
            
            
            guard let longitude = locate!["keido"].int, let latitude = locate!["ido"].int else {
                return
            }
            //リバースジオロケートで緯度経度
            let geocoder = CLGeocoder()
            let location = CLLocation(latitude: Double(latitude), longitude: Double(longitude))

            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let placemarks = placemarks {
                    if let pm = placemarks.first {
                        self.place += pm.administrativeArea ?? ""
                        self.place += pm.locality ?? ""
                    }
                }
                // 画面を再描画する.
                self.collectionView?.reloadData()
            }
        })

        // アイテム表示領域を白色に設定
        collectionView?.backgroundColor = UIColor.white
        
        // セルの再利用のための設定
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
        
        
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

extension MyShabonDetailViewController: UICollectionViewDelegateFlowLayout {
    // 表示するアイテムの数を設定（UICollectionViewDataSource が必要）
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let tmp = locates {
            return tmp["nayami_comments"].count
        }
        return 0
    }
    
    // アイテムの大きさを設定（UICollectionViewDelegateFlowLayout が必要）
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = self.view.frame.width / 4
        
        return CGSize(width: size, height: size)
    }
    
    // アイテム表示領域全体の上下左右の余白を設定（UICollectionViewDelegateFlowLayout が必要）
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let inset =  (self.view.frame.width / 4) / 6
        
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    // アイテムの上下の余白の最小値を設定（UICollectionViewDelegateFlowLayout が必要）
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return (self.view.frame.width / 4) / 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // アイテムを作成
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyShabonCollectionViewCell", for: indexPath)
        
        // アイテムセルを再利用する際、前に追加していた要素（今回はラベル）を削除する
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        
        if let cell = cell as? MyShabonCollectionViewCell {
            if let tmp = locates {
                cell.setupCell(comment: tmp["nayami_comments"][indexPath.row])
            }
        }
        return cell
    }
    
    // アイテムタッチ時の処理（UICollectionViewDelegate が必要）
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        //headerを定義する
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as! topHeader
        
        //headerのLabelのテキストを指定
        header.titleLabel.text = "\(place)で破裂しました"
        
        return header
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        //headerサイズ
        return CGSize(width: view.frame.width, height: 50)
    }
    
    
}
