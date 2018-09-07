//
//  MyShabonDetailCollectionViewCell.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/09/07.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit

class MyShabonDetailCollectionViewCell: UICollectionViewCell {
    

    
    func setupCell(model: [String: String]){
//        title.text = model["mainTitle"]
        
        if let text = model["subTitle"] {
//            subTitle.text = text
        }
        self.backgroundColor = .lightGray
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
