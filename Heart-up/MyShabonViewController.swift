//
//  MyShabonViewController.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/09/03.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit

class MyShabonViewController: UIViewController {
    var post: [[String: Any]] = []
    
    @IBOutlet weak var myShabonTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myShabonTable.register(UINib(nibName: "MyShabonCell", bundle: nil), forCellReuseIdentifier: "MyShabonCell")
        
        
        myShabonTable.dataSource = self
        myShabonTable.delegate = self
        
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
            for locate in locates {
                if let my_shabon = locate.1["nayami"].string {
                    self.data += [my_shabon]
                }
            }
            self.myShabonTable.reloadData()
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

extension MyShabonViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "MyShabonCell") as! MyShabonCell
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    // セクションヘッダーの高さ
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    //Mark: ヘッダーに設定するViewを設定する
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        //ヘッダーにするビューを生成
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50)
        view.backgroundColor = UIColor.lightGray
        
        //ヘッダーに追加するラベルを生成
        let headerLabel = UILabel()
        headerLabel.frame =  CGRect(x: 0, y: 5, width: self.view.frame.size.width, height: 50)
        headerLabel.text = "あなたの飛ばしたシャボン玉一覧"
        headerLabel.textColor = UIColor.white
        headerLabel.textAlignment = NSTextAlignment.center
        view.addSubview(headerLabel)
        return view
    }
}
