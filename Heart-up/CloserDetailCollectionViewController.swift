//
//  CloserDetailCollectionViewController.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/09/16.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit
import SwiftyJSON

class CloserDetailCollectionViewController: UIViewController {
    //idを定義
    var locateId: String?
    var locates: JSON?
    
    // ステータスバーの高さ
    let statusBarHeight = UIApplication.shared.statusBarFrame.height
    
    // セル再利用のための固有名
    let cellId = "itemCell"
    
    //ナビバーの＋ボタンがクリックされた
    @objc func onTapAddComment() {
        // アラートの作成.
        let alertController = UIAlertController(title: "", message: "コメントを入力してください。", preferredStyle: .alert)
        
        // 入力フィールドを追加.
        alertController.addTextField { (textField) in
            textField.placeholder = "コメント"
        }
        
        // 「投稿する」ボタンを設置.
        let confirmAction = UIAlertAction(title: "投稿する", style: .default) { (_) in
            // タップされたら、入力内容を取得する.
            guard let comment = alertController.textFields?[0].text else {
                return
            }
            
            if comment == "" {
                self.showAlert(message: "コメントを入力してね", hide: {})
                return
            }
            
            guard let anno_id = Int(self.locateId!) else {
                return
            }
            //ポストします
            NayamiComment.nayamiCommentPost(locate_info_id: anno_id, comment: comment, callback: { error in
                if let error = error {
                    if let message = error["message"] as? String {
                        self.showAlert(message: message, hide: {})
                    } else {
                        self.showAlert(message: "エラーが発生しました", hide: {})
                    }
                    return
                }
                self.showAlert(message: "投稿しました", hide: {})
                // 大きさとレイアウトを指定して UICollectionView を作成
                let MyShabonDetailCollection = UICollectionView(
                    frame: CGRect(x: 0, y: self.statusBarHeight, width: self.view.frame.width, height: self.view.frame.size.height - self.statusBarHeight),
                    collectionViewLayout: UICollectionViewFlowLayout())
                // コメントデータの再読み込み.
                self.fetchData(collection: MyShabonDetailCollection)
            })
        }
        alertController.addAction(confirmAction)
        
        // 「キャンセル」ボタンを設置.
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (_) in }
        alertController.addAction(cancelAction)
        
        // アラートを表示する.
        self.present(alertController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // 大きさとレイアウトを指定して UICollectionView を作成
        let MyShabonDetailCollection = UICollectionView(
            frame: CGRect(x: 0, y: statusBarHeight, width: self.view.frame.width, height: self.view.frame.size.height - statusBarHeight),
            collectionViewLayout: UICollectionViewFlowLayout())
        
        fetchData(collection: MyShabonDetailCollection)
        
        // ナビゲーション右上に「+」ボタンを追加.
        // タップしたら onTapAddComment メソッドを呼び出す.
        let navItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(detailShabonViewController.onTapAddComment
            ))
        self.navigationItem.setRightBarButton(navItem, animated: true)
        
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

extension CloserDetailCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // 表示するアイテムの数を設定（UICollectionViewDataSource が必要）
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
    
    // アイテムの表示内容（UICollectionViewDataSource が必要）
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // アイテムを作成
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = UIColor.lightGray
        
        // アイテムセルを再利用する際、前に追加していた要素（今回はラベル）を削除する
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        
        if let tmp = locates {
            // テキストラベルを設定して表示
            let label = UILabel()
            label.font = UIFont(name: "Arial", size: 12)
            label.text = tmp["nayami_comments"][indexPath.row]["nayami_comment"].string
            label.numberOfLines = 0
            label.frame = CGRect(x: 0, y: 0, width: self.view.frame.width / 5, height: 0)
            label.sizeToFit()
            label.center = cell.contentView.center
            cell.contentView.addSubview(label)
            return cell
        }
        
        return cell
    }
    
    // アイテムタッチ時の処理（UICollectionViewDelegate が必要）
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
}

extension CloserDetailCollectionViewController {
    func fetchData(collection: UICollectionView){
        
        guard let shabonId = locateId else {
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
            
            //タイトルを設定
            self.title = self.locates!["nayami"].string
            
            // 画面全体に色を設定
            if self.locates!["color"].string == "赤" {
                self.view.backgroundColor = UIColor.red
            } else if self.locates!["color"].string == "青" {
                self.view.backgroundColor = UIColor.blue
            } else if self.locates!["yellow"].string == "黄" {
                self.view.backgroundColor = UIColor.yellow
            }
            // UICollectionView を表示
            self.view.addSubview(collection)
            // 画面を再描画する.
            collection.reloadData()
        })
        // アイテム表示領域を白色に設定
        collection.backgroundColor = UIColor.white
        
        // セルの再利用のための設定
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
        collection.dataSource = self
        collection.delegate = self
    }
}

