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
    
    @IBOutlet weak var nayamiComment: UILabel!
    
    func setupCell(comment: JSON?, color: String) {
        if let comment = comment {
            nayamiComment.text = comment["nayami_comment"].string!
        }
        let redColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 0.5827803938)
        let blueColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 0.5)
        let yellowColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 0.6816941353)
        switch color  {
        case "赤":
            self.backgroundColor = redColor
        case "青":
            self.backgroundColor = blueColor
        case "黄":
            self.backgroundColor = yellowColor
        default:
            print("エラー")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
