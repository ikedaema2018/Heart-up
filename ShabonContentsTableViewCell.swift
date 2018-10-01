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
    
    var comment: JSON? {
        didSet {
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
            let color = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 0.3256902825)
            nayamiLabel.text = comment["nayami_comment"].string
            nayamiView.backgroundColor = color
            nayamiView.layer.cornerRadius = 20
            nayamiView.layer.borderWidth = 0.5
            nayamiView.layer.borderColor = UIColor.black.cgColor
            nayamiView.layer.cornerRadius = 5.0
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
