//
//  MyShabonListCollectionViewController.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/09/30.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit
import SwiftyJSON

private let reuseIdentifier = "Cell"

class MyShabonListCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var posts: [[String: Any]] = []
    var live_posts: [[String: Any]] = []
    var dead_posts: [[String: Any]] = []
    
    
    
    // Sectionのタイトル
    let sectionTitle: NSArray = [
        "飛行中のシャボン玉",
        "弾けたシャボン玉"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // ヘッダーnib登録
        let nib:UINib = UINib(nibName: "MyShabonListReusableView", bundle: nil)
        collectionView?.register(nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "MyShabonListReusableView")

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view.
        fetchData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource
    
    

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionTitle.count
    }
    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return live_posts.count
        } else if section == 1 {
            return dead_posts.count
        } else {
            return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "MyShabonListReusableView", for: indexPath) as? MyShabonListReusableView else {
            fatalError("Could not find proper header")
        }
        if kind == UICollectionElementKindSectionHeader {
            header.sectionHeader.text = sectionTitle[indexPath.section] as? String
            return header
        }
        return UICollectionReusableView()
    }
    
    // アイテムの大きさを設定（UICollectionViewDelegateFlowLayout が必要）
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = self.view.frame.width / 3.5
        return CGSize(width: size, height: size)
    }
    
    // アイテム表示領域全体の上下左右の余白を設定（UICollectionViewDelegateFlowLayout が必要）
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let inset =  (self.view.frame.width / 4) / 18
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    // アイテムの上下の余白の最小値を設定（UICollectionViewDelegateFlowLayout が必要）
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return (self.view.frame.width / 4) / 18
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyShabonListCell", for: indexPath)
        if let cell = cell as? MyShabonListCell {
            if indexPath.section == 0 {
                cell.setupCell(comment: live_posts[indexPath.row])
            } else if indexPath.section == 1 {
                cell.setupCell(comment: dead_posts[indexPath.row])
            }
        }
        return cell
    }
    
    // アイテムタッチ時の処理（UICollectionViewDelegate が必要）
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.performSegue(withIdentifier: "toShabonContents", sender: live_posts[indexPath.row]["id"])
        } else if indexPath.section == 1 {
            self.performSegue(withIdentifier: "toShabonContents", sender: dead_posts[indexPath.row]["id"])
        }
    }
    // Segueでの画面遷移時に呼び出される.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // コメント一覧への遷移の場合.
        if segue.identifier == "toShabonContents" {
            // 選択された投稿データをコメントViewControllerへ渡す.
            if let id = sender as? Int {
                let vc = segue.destination as! ShabonContentsViewController
                vc.id = String(id)
                //テストのためにとりあえず
                vc.happyGraduationFlag = true
            }
        }
    }
}

extension MyShabonListCollectionViewController {
    func fetchData(){
        
        collectionView?.register(UINib(nibName: "MyShabonListCell", bundle: nil), forCellWithReuseIdentifier: "MyShabonListCell")
        // 自分の投稿したシャボン玉を呼び出す処理
        StockLocateInfos.getMyShabon(callback:{ error, locates in
            if let error = error {
                if let message = error["message"] {
                    print(message)
                }
                print("不明なエラーが発生しました")
                return
            }
            guard let locates = locates else {
                print("位置情報をとってこれませんでした")
                return
            }
            //初期化
            self.live_posts = []
            self.dead_posts = []
            
            locates.forEach { locate in
                if locate["life_flag"] as! Int == 1 {
                    self.dead_posts.append(locate)
                } else {
                    self.live_posts.append(locate)
                }
            }
            self.collectionView?.reloadData()
        })
        // セルの再利用のための設定
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
}
