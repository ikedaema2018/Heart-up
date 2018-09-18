//
//  MyShabonCollectionViewCell.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/09/18.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit
import SwiftyJSON

class MyShabonCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var nayamiComment: UILabel!
    
    
    
    func setupCell(comment: JSON?) {
        if let comment = comment {
            print("---------------------------------")
            print(comment["user_id"].int!)
            print(comment["nayami_comment"].string!)
            userName.text = String(comment["user_id"].int!)
            nayamiComment.text = comment["nayami_comment"].string!
        }
        self.backgroundColor = UIColor.lightGray
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
