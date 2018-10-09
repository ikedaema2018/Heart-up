//
//  replyCommentTableViewCell.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/10/08.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit
import SwiftyJSON

class replyCommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userProfile: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    
    var shabonColor: String?
    var reply: JSON? {
        didSet {
            guard let reply = reply else { return }
            commentLabel.text = reply["reply_comment"].string
            let user_image = reply["user"]["profile_image"].string
            if user_image != nil {
                let image_path = user_image
                let url = "http://s3-ap-northeast-1.amazonaws.com/heartup/images/" + image_path!
                self.userProfile.downloadedFrom(link: url)
            }else{
                self.userProfile.image = UIImage(named: "myPage")
            }
            if let shabonColor = shabonColor {
                var color: UIColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 0.1816941353)
                switch shabonColor {
                case "青":
                    color = #colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 0.1478756421)
                case "赤":
                    color = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 0.1504708904)
                case "黄":
                    color = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 0.154885488)
                default:
                    print("シャボンカラーがないよ！")
                }
                commentLabel.backgroundColor = color
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
