//
//  MyShabonListReusableView.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/10/01.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit

class MyShabonListReusableView: UICollectionReusableView {
    
    @IBOutlet weak var sectionHeader: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        let color = #colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 0.2581603168)
        // Initialization code
        self.backgroundColor = color
    }
    
}
