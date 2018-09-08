//
//  AllCommentsTableViewCell.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/09/08.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit

class AllCommentsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var shabonOwnerAvater: UIImageView!
    @IBOutlet weak var shabonOwner: UILabel!
    @IBOutlet weak var shabonColor: UIImageView!
    @IBOutlet weak var nayamiTitle: UILabel!
    
    
    // 投稿データ.
    var locate: [String: Any]? {
        
        // 値がセットされた時に呼び出される処理.
        didSet {
            
            // 値がなければ終わり.
            guard let locate = locate else {
                return
            }
            
            // 画像表示は一旦初期化.
            self.shabonOwnerAvater.image = UIImage(named: "myPage")
            self.shabonColor.image = UIImage(named: "myPage")
            
            
            
            // 投稿本文の表示.
            if let body = locate["nayami"] as? String {
                self.nayamiTitle.text = body
            }
            if let color = locate["color"] as? String {
                if color == "青" {
                    self.shabonColor.image = UIImage(named: "blue")
                } else if color == "黄" {
                    self.shabonColor.image = UIImage(named: "yellow")
                } else if color == "赤" {
                    self.shabonColor.image = UIImage(named: "red")
                }
            }
            
            if let user = locate["user"] as? [String: Any] {
                if let user_name = user["user_name"] as? String {
                    shabonOwner.text = "\(user_name)さんのシャボン玉"
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
