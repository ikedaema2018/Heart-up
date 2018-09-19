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
    @IBOutlet weak var touka_star: UIImageView!
    
    
    func setupCell(comment: JSON?, color: String) {
        guard let user_id = UserDefaults.standard.string(forKey: "user_id") else {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.showLoginStoryboard()
            }
            return
        }
        
        if let comment = comment {
            nayamiComment.text = comment["nayami_comment"].string!
            //テキストサイズ調整
            nayamiComment.adjustsFontSizeToFitWidth = true
            //もし自分のコメントならtrueに
            if user_id == String(comment["user_id"].int!) {
                touka_star.image = UIImage(named: "sin_touka_star")
            }
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
