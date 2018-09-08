//
//  detailShabonViewController.swift
//  
//
//  Created by 前田啓 on 2018/08/29.
//

import UIKit

class detailShabonViewController: UIViewController {
    
    //idを定義
    var locateId: String?

    @IBOutlet weak var nayamiLabel: UILabel!
    @IBOutlet weak var commentsTable: UITableView!
    var data: [String] = []
    
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
    
    
//    @IBAction func commentAction(_ sender: Any) {
//
//        guard let anno_id = locateId else {
//            return
//        }
//        guard let annoId = Int(anno_id) else {
//            return
//        }
    
//        guard let comment = commentInput.text else {
//            errorLabel.isHidden = false
//            errorLabel.text = "コメントを入力してから送信してね"
//            return
//        }
//        if comment == "" {
//            errorLabel.isHidden = false
//            errorLabel.text = "コメントを入力してから送信してね"
//            return
//        }
    
        //ポストします
//        NayamiComment.nayamiCommentPost(locate_info_id: annoId, comment: comment, callback: { error in
//            if let error = error {
//                if let message = error["message"] as? String {
//                    self.showAlert(message: message, hide: {})
//                } else {
//                    self.showAlert(message: "エラーが発生しました", hide: {})
//                }
//                return
//            }
//            self.showAlert(message: "投稿しました", hide: {})
//        })
//    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ナビゲーション右上に「+」ボタンを追加.
        // タップしたら onTapAddComment メソッドを呼び出す.
        let navItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(detailShabonViewController.onTapAddComment
            ))
        self.navigationItem.setRightBarButton(navItem, animated: true)
        
//        commentInput.delegate = self
//        commentInput.placeholder = "この悩みにコメントする"
//        errorLabel.isHidden = true
        
        self.fetchData()
        //TableView用
        commentsTable.delegate = self
        commentsTable.dataSource = self
        
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

extension detailShabonViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension detailShabonViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "myCell")
            cell.textLabel?.text = data[indexPath.row]
            return cell
    }
    
}

extension detailShabonViewController {
    // APIからコメント一覧を取得する.
    func fetchData() {
        //ここにIDで検索する処理をかく
        guard let annoId = locateId else {
            return
        }
        
        StockLocateInfos.getDetailLocation(id: annoId, callback: {error, locate in
            
            if let error = error {
                if let message = error["message"] as? String {
                    print(message)
                    print("不明なエラーが発生しました")
                } else {
                    print("不明なエラーが発生しました")
                }
                return
            }
            
            guard let locate = locate else {
                return
            }
            
            
            let nayami_comment_array = locate["nayami_comments"]
            
            for nayami in nayami_comment_array {
                if let nayami_comment = nayami.1["nayami_comment"].string {
                    self.data += [nayami_comment]
                }
            }
            self.nayamiLabel.text = locate["nayami"].string
            self.commentsTable.reloadData()
        })
    }
}
