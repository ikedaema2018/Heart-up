//
//  ShabonContentsTableViewCell.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/10/01.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit
import SwiftyJSON

class ShabonContentsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userProfile: UIImageView!
    @IBOutlet weak var nayamiView: UIView!
    @IBOutlet weak var nayamiLabel: UILabel!
    @IBOutlet weak var toukou_day: UILabel!
    @IBOutlet weak var stampView: UIImageView!
    @IBOutlet weak var replyOutret: UIButton!
    @IBOutlet weak var replyView: UIView!
    @IBOutlet weak var replyLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    
    var shabonColor: String?
    var comment: JSON? {
        didSet {
            //iineボタンを押したら表示させる
            let reactionView = UIView()
            
            
            replyView.isHidden = true
            userProfile.isHidden = false
            nayamiView.isHidden = false
            replyOutret.isHidden = false
            replyOutret.layer.cornerRadius = 13
            userProfile.clipsToBounds = true
            guard let comment = comment else {
                return
            }
            let user_image = comment["user"]["profile_image"].string
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
                    color = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 0.1816941353)
                case "赤":
                    color = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 0.1825770548)
                case "黄":
                    color = #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 0.1777076199)
                default:
                    print("シャボンカラーがないよ！")
                }
                nayamiLabel.backgroundColor = color
            }
            
            //文字列をDate型にformatするコピペ
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZ'"
            if let date = formatter.date(from: comment["created_at"].string!) {
                formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy年MM月dd日(EEE） HH時mm分", options: 0, locale: Locale(identifier: "ja_JP"))
                let dateStr = formatter.string(from: date).description
                toukou_day.text = dateStr
                toukou_day.font = UIFont.systemFont(ofSize: 11)
            }
            
            if comment["nayami_comment"].string != nil {
                stampView.isHidden = true
                nayamiLabel.isHidden = false
                nayamiLabel.text = comment["nayami_comment"].string
                //            nayamiView.layer.cornerRadius = 20
                nayamiLabel.layer.borderWidth = 0.5
                nayamiLabel.layer.borderColor = UIColor.black.cgColor
                nayamiLabel.layer.cornerRadius = 5.0
            }
            if let stampId = comment["stamp_id"].int {
                nayamiLabel.isHidden = true
                stampView.isHidden = false
                if stampId == 1 {
                    stampView.image = UIImage(named: "awa")
                } else if stampId == 2 {
                    stampView.image = UIImage(named: "bittkuri")
                } else if stampId == 3 {
                    stampView.image = UIImage(named: "gurottuki-")
                } else if stampId == 4 {
                    stampView.image = UIImage(named: "ase")
                }
            }
        }
    }
    
    var reply: JSON? {
        didSet {
            userProfile.isHidden = true
            nayamiView.isHidden = true
            replyOutret.isHidden = true
            replyView.isHidden = false
            
            guard let reply = reply else { return }
            replyLabel.text = reply["reply_comment"].string
            let user_image = reply["user"]["profile_image"].string
            if user_image != nil {
                let image_path = user_image
                let url = "http://s3-ap-northeast-1.amazonaws.com/heartup/images/" + image_path!
                self.userImage.downloadedFrom(link: url)
            }else{
                self.userImage.image = UIImage(named: "myPage")
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
                replyLabel.backgroundColor = color
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
