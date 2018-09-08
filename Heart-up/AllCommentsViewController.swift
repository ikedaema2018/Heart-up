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
    var posts: [[String: Any]] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        allCommentShabonTable.register(UINib(nibName: "AllCommentsTableViewCell", bundle: nil), forCellReuseIdentifier: "AllCommentCustomCell")
        
        allCommentShabonTable.dataSource = self
        allCommentShabonTable.delegate = self
        
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
            
            self.posts = locates
            self.allCommentShabonTable.reloadData()
        })

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

extension AllCommentsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = allCommentShabonTable.dequeueReusableCell(withIdentifier: "AllCommentCustomCell", for: indexPath) as! AllCommentsTableViewCell
        cell.locate = posts[indexPath.row]
        return cell
    }
    
    //行がタップされた時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //選択状態を非表示にする
        allCommentShabonTable.deselectRow(at: indexPath, animated: true)
        let post = self.posts[indexPath.row]
        let post1 = post["id"]
        //            print(post1)
        // コメント一覧へ遷移する.
        self.performSegue(withIdentifier: "AllCommentCollectionSegue", sender: post1)
    }
    
    // Segueでの画面遷移時に呼び出される.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // コメント一覧への遷移の場合.
        if segue.identifier == "AllCommentCollectionSegue" {
            // 選択された投稿データをコメントViewControllerへ渡す.
            if let id = sender as? Int {
                let vc = segue.destination as! AllCommentsCollectionViewController
                vc.id = String(id)
            }
        }
    }
    
    
}

