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
    var nayamiAndReply: [JSON] = []
    var color: String?
    var flag = false
    var happyGraduationFlag = false
    
    @IBOutlet weak var stampView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var commentInput: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    

    @IBAction func stampbutton(_ sender: Any) {
        stampView.isHidden = false
    }
    @IBAction func awaButton(_ sender: Any) {
        postNayami(comment: nil, stampId: 1)
        stampView.isHidden = true
    }
    @IBAction func surprise(_ sender: Any) {
        postNayami(comment: nil, stampId: 2)
        stampView.isHidden = true
    }
    @IBAction func tired(_ sender: Any) {
        postNayami(comment: nil, stampId: 3)
        stampView.isHidden = true
    }
    @IBAction func ase(_ sender: Any) {
        postNayami(comment: nil, stampId: 4)
        stampView.isHidden = true
    }
    @IBAction func closeButton(_ sender: Any) {
        stampView.isHidden = true
    }
    
    @IBAction func postButton(_ sender: Any) {
        // タップされたら、入力内容を取得する.
        guard let comment = commentInput.text else {
            self.showAlert(message: "コメントを入力してね", hide: {})
            return
        }
        
        if commentInput.text == "" {
            self.showAlert(message: "コメントを入力してね", hide: {})
            return
        }
        postNayami(comment: comment, stampId: nil)
    }
    
    //逆ジオロケのため
    var place = ""
    var fPlace = ""
    var kyori: Double = 0.0
    
    @IBOutlet weak var contentsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stampView.isHidden = true
        contentsTable.register(UINib(nibName: "ShabonContentsTableViewCell", bundle: nil), forCellReuseIdentifier: "ShabonContentsCell")
        contentsTable.register(UINib(nibName: "replyCommentTableViewCell", bundle: nil), forCellReuseIdentifier: "replyCommentTableViewCell")
        contentsTable.delegate = self
        contentsTable.dataSource = self
        commentInput.delegate = self
        
        contentsTable.rowHeight = UITableViewAutomaticDimension
        
//        contentsTable.estimatedRowHeight = 44.0
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // キーボードイベントの監視開始
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.handleKeyboardWillShowNotification(_:)), name: .UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(self.handleKeyboardWillHideNotification(_:)), name: .UIKeyboardWillHide, object: nil)
        
        fetchData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserver()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ShabonContentsViewController: UITableViewDelegate, UITableViewDataSource {
    
    // セクション数を返却する.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let locates = locates {
            var replyAll = 0
            //全てのnayami_commentsに含まれるreplyの総数
            for nayamiComment in locates["nayami_comments"] {
                replyAll += nayamiComment.1["reply_comments"].count
            }
            return locates["nayami_comments"].count + replyAll
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //もしreplyコメントなら
        if nayamiAndReply[indexPath.row]["reply_comment"] != nil {
            //返信なら
            let cell = contentsTable.dequeueReusableCell(withIdentifier: "replyCommentTableViewCell", for: indexPath) as! replyCommentTableViewCell
            if let color = color {
                cell.shabonColor = color
            }
            cell.reply = nayamiAndReply[indexPath.row]
            let tapGesture = UserTapGestureRecognizer(target: self, action: #selector(self.tapUserImage(sender:)))
            tapGesture.userId = nayamiAndReply[indexPath.row]["user_id"].int!
            cell.userProfile.addGestureRecognizer(tapGesture)
            return cell
        }else
        {
            let cell = contentsTable.dequeueReusableCell(withIdentifier: "ShabonContentsCell", for: indexPath) as! ShabonContentsTableViewCell

            if let color = color {
                cell.shabonColor = color
            }
            //replyButtonを認識するための
            cell.replyOutret.tag = nayamiAndReply[indexPath.row]["id"].int!
            cell.replyOutret.addTarget(self, action: #selector(self.replyViewDisplay), for: .touchDown)
            cell.comment = nayamiAndReply[indexPath.row]
            cell.row = indexPath.row
            cell.locateId = id
            cell.contentsTable = contentsTable
            let tapGesture = UserTapGestureRecognizer(target: self, action: #selector(self.tapUserImage(sender:)))
            tapGesture.userId = nayamiAndReply[indexPath.row]["user_id"].int!
            cell.userProfile.addGestureRecognizer(tapGesture)
            return cell
        }
    }
    //Mark: ヘッダーの大きさを設定する
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 80
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
            locateLabel.text = "\(place)にいます(総移動距離\(String(format: "%.1f", kyori))km)"
            locateLabel.font = UIFont.systemFont(ofSize: 12)
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
        nayamiLabel.layer.masksToBounds = true
        view.addSubview(locateLabel)
        view.addSubview(nayamiLabel)
        return view
    }
    
    //行がタップされた時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //選択状態を非表示にする
//        contentsTable.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "contentsToUser" {
            if let id = sender as? Int {
                let vc = segue.destination as! UserInfoViewController
                vc.userId = String(id)
            }
        } else if segue.identifier == "tohappyGraduationSegue" {
            let vc = segue.destination as! HappyGraduationViewController
            vc.locates = locates
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
            
            //もし弾けたシャボン玉だったらの場合わけ
            if locate!["life_flag"].bool == true {
                self.bottomView.isHidden = true
            }
            
            self.nayamiAndReply = []
            let nayamiIdSort = locate!["nayami_comments"].sorted { $0.1["id"].int! < $1.1["id"].int! }
            
            //locateを回してnayami_commentsとreplyを足した配列を作る
            for i in 0..<nayamiIdSort.count {
                self.nayamiAndReply.append(nayamiIdSort[i].1)
                if !nayamiIdSort[i].1["reply_comments"].isEmpty {
                    for reply in nayamiIdSort[i].1["reply_comments"] {
                        self.nayamiAndReply.append(reply.1)
                    }
                }
            }
            
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
                //もし["first_locates"]がnilじゃなかったら距離を取得
                let firstLocate = self.locates!["first_locate"]

                guard let fLatitude = firstLocate["ido"].double, let fLongitude = firstLocate["keido"].double else {
                    return
                }
                self.kyori = Distance.distance(current: (la: latitude, lo: longitude), target: (la: fLatitude, lo: fLongitude))
                        // 再読み込み
                        self.contentsTable.reloadData()
                
                
                //もしアラートから来ていたらhappyGraduationへ飛ばす
                if self.happyGraduationFlag == true {
                    self.performSegue(withIdentifier: "tohappyGraduationSegue", sender: nil)
                }
                }
            
            //もしシャボン玉を投稿した人が自分だったら+ボタンを表示しない
            guard let userId = UserDefaults.standard.string(forKey: "user_id") else {
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    appDelegate.showLoginStoryboard()
                }
                return
            }
            var shabonUser = String(self.locates!["user_id"].int!)
            //   これをif文の中に入れることを忘れずに         userId != shabonUser &
            if  self.locates!["nayami_comments"].count < 9 {
                //チャットを消す
                
            }
        })
    }
}

extension ShabonContentsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // キーボードが現れた時に、画面全体をずらす。
    @objc private func handleKeyboardWillShowNotification(_ notification: Notification) {
        let userInfo = notification.userInfo //この中にキーボードの情報がある
        let keyboardSize = (userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardY = self.view.frame.size.height - keyboardSize.height //画面全体の高さ - キーボードの高さ = キーボードが被らない高さ
        let editingTextFieldY: CGFloat = (self.bottomView?.frame.origin.y)!
        if flag == false {
            flag = true
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
                self.view.frame = CGRect(x: 0, y: self.view.frame.origin.y - (editingTextFieldY - (keyboardY - 80)), width: self.view.bounds.width, height: self.view.bounds.height)
            }, completion: nil)
        }
    }
    
    // キーボードが消えたときに、画面を戻す
    @objc private func handleKeyboardWillHideNotification(_ notification: Notification) {
        flag = false
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        }, completion: nil)
    }
}

extension ShabonContentsViewController {
    // Notificationを削除
    func removeObserver() {
        let notification = NotificationCenter.default
        notification.removeObserver(self)
    }
}

extension ShabonContentsViewController {
    
    func postNayami(comment: String?, stampId: Int?){
        guard let anno_id = Int(self.id!) else {
            return
        }
        
        //ポストします
        NayamiComment.nayamiCommentPost(locate_info_id: anno_id, comment: comment, stampId: stampId, callback: { error in
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
                    
                    let returnAction = UIAlertAction(title: "OK", style: .default) { (_) in
                        //showLocateAlertに戻る処理
                        self.navigationController?.popViewController(animated: true)
                    }
                    returnController.addAction(returnAction)
                    self.present(returnController, animated: true, completion: nil)
                }
            })
            self.commentInput.text = ""
            // コメントデータの再読み込み.
            self.fetchData()
        })
    }
    
    @objc func replyViewDisplay(sender:UIButton){
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
        
                    //ポストします
                    ReplyComment.replyCommentPost(nayami_comment_id: sender.tag, comment: comment, callback: { error in
                        if let error = error {
                            if let message = error["message"] as? String {
                                self.showAlert(message: message, hide: {})
                            } else {
                                self.showAlert(message: "エラーが発生しました", hide: {})
                            }
                            return
                        }
                        self.showAlert(message: "返信しました", hide: { ()-> Void in
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
    
    @objc private func tapUserImage(sender: UserTapGestureRecognizer){
        // コメント一覧へ遷移する.
                self.performSegue(withIdentifier: "contentsToUser", sender: sender.userId!)
    }
    
}
