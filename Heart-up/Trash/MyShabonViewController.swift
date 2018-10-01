//
//  MyShabonViewController.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/09/03.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit

class MyShabonViewController: UIViewController {
    var live_posts: [[String: Any]] = []
    var dead_posts: [[String: Any]] = []
    var posts: [[String: Any]] = []
    
    // Sectionのタイトル
    let sectionTitle: NSArray = [
        "飛行中のシャボン玉",
        "弾けたシャボン玉"]
    
    @IBOutlet weak var myShabonTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myShabonTable.register(UINib(nibName: "MyShabonTableViewCell", bundle: nil), forCellReuseIdentifier: "MyShabonCell")
        
        myShabonTable.dataSource = self
        myShabonTable.delegate = self
        
//        // 自分の投稿したシャボン玉を呼び出す処理
//        StockLocateInfos.getMyShabon(callback:{ error, locates in
//            if let error = error {
//                if let message = error["message"] {
//                    print(message)
//                }
//                print("不明なエラーが発生しました")
//                return
//            }
//            guard let locates = locates else {
//                print("位置情報をとってこれませんでした")
//                return
//            }
//            locates.forEach { locate in
//                if locate["life_flag"] as! Int == 1 {
//                    self.dead_posts.append(locate)
//                } else {
//                    self.live_posts.append(locate)
//                }
//            }
//
////            self.posts = locates
//            self.myShabonTable.reloadData()
//        })
        
        
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension MyShabonViewController: UITableViewDelegate, UITableViewDataSource {
    
    // セクション数を返却する.
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    // Sectioのタイトル
    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section] as? String
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return live_posts.count
        } else if section == 1 {
            return dead_posts.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myShabonTable.dequeueReusableCell(withIdentifier: "MyShabonCell", for: indexPath) as! MyShabonTableViewCell
        if indexPath.section == 0 {
            cell.locate = live_posts[indexPath.row]
        } else {
            cell.locate = dead_posts[indexPath.row]
        }
        return cell
    }
    
    //行がタップされた時
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            //選択状態を非表示にする
            myShabonTable.deselectRow(at: indexPath, animated: true)
            let locate_id: Any?
            if indexPath.section == 0 {
                let post = self.live_posts[indexPath.row]
                locate_id = post["id"]
            } else if indexPath.section == 1 {
                let post = self.dead_posts[indexPath.row]
                locate_id = post["id"]
            } else { locate_id = 0 }
            
            // コメント一覧へ遷移する.
            self.performSegue(withIdentifier: "myShabonDetailSegue", sender: locate_id)
        }
    
    
    
    
    
    // セクションヘッダーの高さ
//    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 50
//    }
    
    //Mark: ヘッダーに設定するViewを設定する
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
    
        //ヘッダーにするビューを生成
//        let view = UIView()
//        view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50)
//        view.backgroundColor = UIColor.lightGray
    
        //ヘッダーに追加するラベルを生成
//        let headerLabel = UILabel()
//        headerLabel.frame =  CGRect(x: 0, y: 5, width: self.view.frame.size.width, height: 50)
//        headerLabel.text = "あなたの飛ばしたシャボン玉一覧"
//        headerLabel.textColor = UIColor.white
//        headerLabel.textAlignment = NSTextAlignment.center
//        view.addSubview(headerLabel)
//        return view
//    }
    
    // Segueでの画面遷移時に呼び出される.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // コメント一覧への遷移の場合.
        if segue.identifier == "myShabonDetailSegue" {
            // 選択された投稿データをコメントViewControllerへ渡す.
            if let id = sender as? Int {
                let vc = segue.destination as! MyShabonDetailViewController
                vc.id = String(id)
            }
        }
    }
}

extension MyShabonViewController {
    func fetchData(){
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
            
            //            self.posts = locates
            self.myShabonTable.reloadData()
        })
    }
}
