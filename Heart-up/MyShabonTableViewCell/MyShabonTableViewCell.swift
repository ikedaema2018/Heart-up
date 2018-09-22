//
//  MyShabonTableViewCell.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/09/06.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit

class MyShabonTableViewCell: UITableViewCell {
    @IBOutlet weak var myShabonImage: UIImageView!
    
    @IBOutlet weak var myShabonTitle: UILabel!
    @IBOutlet weak var myShabonCount: UIImageView!
    @IBOutlet weak var newNayami: UIImageView!
    
    
    // 投稿データ.
    var locate: [String: Any]? {
        
        // 値がセットされた時に呼び出される処理.
        didSet {
            
            // 値がなければ終わり.
            guard let locate = locate else {
                return
            }
            
            let nayami_comment = locate["nayami_comments"] as! [[String: Any]]
            
            //まだ見てないコメントがある時にnew_flag
            let bool = locate["life_flag"] as! Bool
            print(bool)
            if bool == false {
                let yonda = nayami_comment.filter { $0["yonda_flag"] as! Bool == false }
                if yonda.count > 0 {
                    newNayami.image = UIImage(named: "new")
                }else{
                    newNayami.image = nil
                }
            }
            
            
            //悩みコメントの数のイメージを設定
            myShabonCount.image = UIImage(named: "number" + String(nayami_comment.count))
            
            // 画像表示は一旦初期化.
            self.myShabonImage.image = UIImage(named: "japan")
            
            // 投稿本文の表示.
            if let body = locate["nayami"] as? String {
                self.myShabonTitle.text = body
            }
            if let color = locate["color"] as? String {
                if color == "青" {
                    self.myShabonImage.image = UIImage(named: "blue")
                } else if color == "黄" {
                    self.myShabonImage.image = UIImage(named: "yellow")
                } else if color == "赤" {
                    self.myShabonImage.image = UIImage(named: "red")
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

