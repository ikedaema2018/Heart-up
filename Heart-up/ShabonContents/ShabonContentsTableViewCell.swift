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

    
    var shabonColor: String?
    var comment: JSON? {
        didSet {
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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
