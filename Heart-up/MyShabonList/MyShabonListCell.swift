//
//  MyShabonListCell.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/09/30.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit

class MyShabonListCell: UICollectionViewCell {

    @IBOutlet weak var shabonTitle: UILabel!
    
    func setupCell(comment: [String: Any]) {
        shabonTitle.text = comment["nayami"] as! String
        shabonTitle.sizeToFit()
        
        let color = comment["color"] as! String
        let red = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 0.4161761558)
        let blue = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 0.3145066353)
        let yellow = #colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 0.5292701199)
        
        switch color {
        case "赤":
            self.backgroundColor = red
        case "黄":
            self.backgroundColor = yellow
        case "青":
            self.backgroundColor = blue
        default: break
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
