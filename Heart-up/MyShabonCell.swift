//
//  MyShabonCell.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/09/05.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit

class MyShabonCell :UITableViewCell {
    @IBOutlet weak var myShabonImage: UIImageView!
    
    @IBOutlet weak var myShabonTitle: UILabel!
    
    
    // 投稿データ.
    var post: [String: Any]? {
        
        // 値がセットされた時に呼び出される処理.
        didSet {
            
            // 値がなければ終わり.
            guard let post = post else {
                return
            }
            
            // 画像表示は一旦初期化.
            self.myShabonImage.image = UIImage(named: "blue")
            
            
            // 投稿本文の表示.
            if let body = post["nayami"] as? String {
                self.myShabonTitle.text = body
            }
            
        }
    }
}

