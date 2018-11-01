//
//  AllCommentsViewController.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/09/03.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit


class AllCommentsViewController: UIViewController {
    
    @IBOutlet weak var allCommentShabonTable: UITableView!
    var live_posts: [[String: Any]] = []
    var dead_posts: [[String: Any]] = []
    var posts: [[String: Any]] = []
    
    // Sectionのタイトル
    let sectionTitle: NSArray = [
        "飛行中のシャボン玉",
        "弾けたシャボン玉"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        allCommentShabonTable.register(UINib(nibName: "AllCommentsTableViewCell", bundle: nil), forCellReuseIdentifier: "AllCommentCustomCell")
        allCommentShabonTable.dataSource = self
        allCommentShabonTable.delegate = self
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

extension AllCommentsViewController: UITableViewDelegate, UITableViewDataSource {
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
        let cell = allCommentShabonTable.dequeueReusableCell(withIdentifier: "AllCommentCustomCell", for: indexPath) as! AllCommentsTableViewCell
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
        allCommentShabonTable.deselectRow(at: indexPath, animated: true)
        let locate_info_id: Any?
        if indexPath.section == 0 {
            let post = self.live_posts[indexPath.row]
            locate_info_id = post["locate_info_id"]
        } else if indexPath.section == 1 {
            let post = self.dead_posts[indexPath.row]
            locate_info_id = post["locate_info_id"]
        } else { locate_info_id = 0 }
        // コメント一覧へ遷移する.
        self.performSegue(withIdentifier: "commentToContents", sender: locate_info_id)
    }
    
    // Segueでの画面遷移時に呼び出される.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // コメント一覧への遷移の場合.
        if segue.identifier == "commentToContents" {
            // 選択された投稿データをコメントViewControllerへ渡す.
            if let id = sender as? Int {
                let vc = segue.destination as! ShabonContentsViewController
                vc.id = String(id)
            }
        }
    }
}

extension AllCommentsViewController {
    func fetchData(){
        // 自分の投稿したシャボン玉を呼び出す処理
        NayamiComment.getPostShabon(callback:{ error, locates in
            ErrorModule.shared.errorCheck2(error: error, viewController: self)
            
            guard let locates = locates else {
                print("位置情報をとってこれませんでした")
                return
            }
            
            //初期化
            self.live_posts = []
            self.dead_posts = []
            
            locates.forEach { locate in
                if let locateInfo = locate["locate_info"] as! [String: Any]? {
                    if locateInfo["life_flag"] as! Int == 1 {
                        self.dead_posts.append(locate)
                    } else {
                        self.live_posts.append(locate)
                    }
                }
            }
            self.allCommentShabonTable.reloadData()
        })
    }
}

