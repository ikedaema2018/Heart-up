//
//  detailShabonViewController.swift
//  
//
//  Created by 前田啓 on 2018/08/29.
//

import UIKit
import SwiftyJSON
import CoreLocation

class detailShabonViewController: UIViewController {
    
    //idを定義
    var locateId: String?
    var locates: JSON?
    //逆ジオロケのため
    var place = ""
    let headerId = "headerId"
    let footerId = "footerId"
    
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
            //もしnayami_commentが9個以上だったらキャンセル
            if self.locates!["nayami_comments"].count >= 9 {
                return
            }
            //ポストします
            NayamiComment.nayamiCommentPost(locate_info_id: anno_id, comment: comment, stampId: 1, callback: { error in
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

        // Do any additional setup after loading the view.a
        
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

extension detailShabonViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // 表示するアイテムの数を設定（UICollectionViewDataSource が必要）
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let tmp = locates {
            return tmp["nayami_comments"].count
        }
        return 24
    }
    
    // アイテムの大きさを設定（UICollectionViewDelegateFlowLayout が必要）
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = self.view.frame.width / 3.5
        
        return CGSize(width: size, height: size)
    }
    
    // アイテム表示領域全体の上下左右の余白を設定（UICollectionViewDelegateFlowLayout が必要）
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let inset =  (self.view.frame.width / 4) / 9
        
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    // アイテムの上下の余白の最小値を設定（UICollectionViewDelegateFlowLayout が必要）
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return (self.view.frame.width / 4) / 3
    }
    
    // アイテムの表示内容（UICollectionViewDataSource が必要）
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // アイテムを作成
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyShabonCollectionViewCell", for: indexPath)
        
//        switch indexPath[1] % 4 {
//        case 0:
//            cell.backgroundColor = UIColor.yellow
//        case 1:
//            cell.backgroundColor = UIColor.magenta
//        case 2:
//            cell.backgroundColor = UIColor.orange
//        case 3:
//            cell.backgroundColor = UIColor.purple
//        default:
//            print("collectionのセルの色極めでイレギュラー")
//        }
       
        
        if let cell = cell as? MyShabonCollectionViewCell {
            if let tmp = locates {
                cell.setupCell(comment: tmp["nayami_comments"][indexPath.row], color: tmp["color"].string!)
            }
        }
        return cell
    }
    
    // アイテムタッチ時の処理（UICollectionViewDelegate が必要）
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //これがコメントした人のユーザーID
        let userId = String(locates!["nayami_comments"][indexPath.row]["user_id"].int!)
        self.performSegue(withIdentifier: "toUserInfoSegue", sender: userId)
    }
    
    //ここからヘッダー
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader{
            //headerを定義する
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as! topHeader
            
            if let tmp = locates {
                let color = tmp["color"].string
                switch color {
                case "赤":
                    let red = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 0.3710669949)
                    header.changeColor(color: red)
                case "黄":
                    let yellow = #colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 0.5050567209)
                    header.changeColor(color: yellow)
                case "青":
                    let blue = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 0.3356967038)
                    header.changeColor(color: blue)
                default:
                    print("headerのlocatesにcolorがないよ！")
                }
                //headerテキストへpushする
                header.titleLabel.text = "\(tmp["user"]["user_name"].string!)さんの悩み:\n" + tmp["nayami"].string!
            }
            return header
            
        }else{
            //footerを定義
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerId, for: indexPath) as! bottomFooter
            if let tmp = locates {
                let color = tmp["color"].string
                switch color {
                case "赤":
                    let red = #colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 0.6808379709)
                    footer.changeColor(color: red)
                case "黄":
                    let yellow = #colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 0.8276166524)
                    footer.changeColor(color: yellow)
                case "青":
                    let blue = #colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 0.6197559932)
                    footer.changeColor(color: blue)
                default:
                    print("footerのlocatesにcolorがないよ！")
                }
                
                if tmp["life_flag"].bool! == false {
                    footer.titleLabel.text = "このシャボン玉は今\(place)にいます"
                }else{
                    footer.titleLabel.text = "\(place)で破裂しました"
                }
            }
            return footer
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        //headerサイズ
        return CGSize(width: view.frame.width, height: 100)
    }
    
    //footer
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        //footerサイズ
        return CGSize(width: view.frame.width, height: 50)
    }
}

extension detailShabonViewController {
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
            guard let longitude = locate!["keido"].double, let latitude = locate!["ido"].double else {
                return
            }
            //リバースジオロケートで緯度経度
            let geocoder = CLGeocoder()
            let location = CLLocation(latitude: latitude, longitude: longitude)
            
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let placemarks = placemarks {
                    if let pm = placemarks.first {
                        self.place += pm.administrativeArea ?? ""
                        self.place += pm.locality ?? ""
                    }
                }
            // 画面を再描画する.
            collection.reloadData()
            
            // ナビゲーション右上に「+」ボタンを追加.
            // タップしたら onTapAddComment メソッドを呼び出す.
            //もしそうコメント数が9個以上だったら表示しない
            
//            if self.locates!["nayami_comments"].count < 9 {
            }
        })
        // アイテム表示領域を白色に設定
        collection.backgroundColor = UIColor.white
        
        // セルの再利用のための設定
        collection.register(topHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        collection.register(bottomFooter.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerId)
        collection.register(UINib(nibName: "MyShabonCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MyShabonCollectionViewCell")
        
        collection.dataSource = self
        collection.delegate = self
        
        let navItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(detailShabonViewController.onTapAddComment
            ))
        self.navigationItem.setRightBarButton(navItem, animated: true)
    }
}

extension detailShabonViewController
{
    //ページ遷移で数値を
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let id = sender as? String else {
            return
        }
        
        if segue.identifier == "toUserInfoSegue" {
            if let vc = segue.destination as? UserInfoViewController {
                vc.userId = id
            }
        }
    }
}
