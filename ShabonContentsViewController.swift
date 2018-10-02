//
//  ShabonContentsViewController.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/10/01.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation

class ShabonContentsViewController: UIViewController {
    var id: String?
    var locates: JSON?
    var color: String?
    //逆ジオロケのため
    var place = ""
    
    @IBOutlet weak var contentsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentsTable.register(UINib(nibName: "ShabonContentsTableViewCell", bundle: nil), forCellReuseIdentifier: "ShabonContentsCell")
        contentsTable.delegate = self
        contentsTable.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ShabonContentsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let locates = locates {
            return locates["nayami_comments"].count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contentsTable.dequeueReusableCell(withIdentifier: "ShabonContentsCell", for: indexPath) as! ShabonContentsTableViewCell
        if let locates = locates {
            if let color = color {
                cell.shabonColor = color
            }
            cell.comment = locates["nayami_comments"][indexPath.row]
        }
        return cell
    }
    //Mark: ヘッダーの大きさを設定する
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        
        return 100
    }
    
    //Mark: ヘッダーに設定するViewを設定する
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        
        //ヘッダーにするビューを生成
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 80)
        
        
        //ヘッダーに追加するラベルを生成
        let locateLabel = UILabel()
        locateLabel.frame =  CGRect(x: 0, y: 60, width: self.view.frame.size.width, height: 20)
        let nayamiLabel = UILabel()
        nayamiLabel.numberOfLines = 3
        
        nayamiLabel.frame = CGRect(x: 0, y: 0, width : self.view.frame.size.width, height: 60)
        
        var locateColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        var nayamiColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        if let locates = locates {
            self.title = "\(locates["user"]["user_name"].string!)さんのシャボン玉"
            locateLabel.text = "\(place)を移動中"
            nayamiLabel.text = "\(locates["nayami"].string!)"
            
            let color = locates["color"].string!
            switch color {
            case "青":
                locateColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 0.5000267551)
                nayamiColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 0.6962489298)
            case "赤":
                locateColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 0.1757009846)
                nayamiColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 0.5597174658)
            case "黄":
                locateColor = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 0.6073416096)
                nayamiColor = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
            default:
                print("カラーがないよ！")
            }
        }
        
        locateLabel.textColor = UIColor.white
        nayamiLabel.textColor = UIColor.white
        nayamiLabel.textAlignment = NSTextAlignment.center
        nayamiLabel.backgroundColor = nayamiColor
        locateLabel.backgroundColor = locateColor
        nayamiLabel.layer.cornerRadius = 5
        view.addSubview(locateLabel)
        view.addSubview(nayamiLabel)
        
        return view
    }
    //行がタップされた時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //選択状態を非表示にする
        contentsTable.deselectRow(at: indexPath, animated: true)
        if let locates = locates {
            let id = locates["nayami_comments"][indexPath.row]["user_id"].int
            // コメント一覧へ遷移する.
            self.performSegue(withIdentifier: "contentsToUser", sender: id)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "contentsToUser" {
            if let id = sender as? Int {
                let vc = segue.destination as! UserInfoViewController
                vc.userId = String(id)
            }
        }
    }
}

extension ShabonContentsViewController {
    func fetchData(){
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
//            if self.locates!["color"].string == "赤" {
//                self.view.backgroundColor = UIColor.red
//            } else if self.locates!["color"].string == "青" {
//                self.view.backgroundColor = UIColor.blue
//            } else if self.locates!["color"].string == "黄" {
//                self.view.backgroundColor = UIColor.yellow
//            }
            self.color = self.locates!["color"].string
            
            guard let longitude = locate!["keido"].double, let latitude = locate!["ido"].double else {
                return
            }
            
            //リバースジオロケートで緯度経度
            let geocoder = CLGeocoder()
            let location = CLLocation(latitude: latitude, longitude: longitude)
            
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let placemarks = placemarks {
                    
                    if let pm = placemarks.first {
                        //placeを初期化
                        self.place = ""
                        self.place += pm.administrativeArea ?? ""
                        self.place += pm.locality ?? ""
                        self.place += pm.subLocality ?? ""
                    }
                }
                // 画面を再描画する.
                self.contentsTable.reloadData()
            }
            
            //もしシャボン玉を投稿した人が自分だったら+ボタンを表示しない
            guard let userId = UserDefaults.standard.string(forKey: "user_id") else {
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    appDelegate.showLoginStoryboard()
                }
                return
            }
            var shabonUser = String(self.locates!["user_id"].int!)
            //   これをif文の中に入れることを忘れずに         userId != shabonUser &&
            
            if  self.locates!["nayami_comments"].count < 9 {
                let navItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(MyShabonDetailViewController.onTapAddComment))
                self.navigationItem.setRightBarButton(navItem, animated: true)
            }
        })
    }
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
            
            guard let anno_id = Int(self.id!) else {
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
                self.showAlert(message: "投稿しました", hide: { ()-> Void in
                    if self.locates!["nayami_comments"].count >= 9 {
                        //アラートを出し、dismissでshowlocateに戻す
                        // アラートの作成.
                        let returnController = UIAlertController(title: "", message: "シャボン玉が破裂しました", preferredStyle: .alert)
                        
                        // 「投稿する」ボタンを設置.
                        let returnAction = UIAlertAction(title: "OK", style: .default) { (_) in
                            //showLocateAlertに戻る処理
                            self.navigationController?.popViewController(animated: true)
                        }
                        returnController.addAction(returnAction)
                        self.present(returnController, animated: true, completion: nil)
                    }
                })
                
                // コメントデータの再読み込み.
                self.fetchData()
            })
        }
        alertController.addAction(confirmAction)
        
        // 「キャンセル」ボタンを設置.
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (_) in }
        alertController.addAction(cancelAction)
        
        // アラートを表示する.
        self.present(alertController, animated: true, completion: nil)
    }
}

