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
    
    @IBOutlet weak var uiLabel: UILabel!
    
    var comment: JSON? {
        didSet {
            guard let comment = comment else {
                return
            }
            uiLabel.text = comment["nayami_comment"].string
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
