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
    @IBOutlet weak var newNayami: UIImageView!
    @IBOutlet weak var myShabonCount: UIImageView!
    
    @IBOutlet weak var shabonBackGround: UIView!
    
    func setupCell(comment: [String: Any]) {
        shabonTitle.text = comment["nayami"] as! String
        shabonTitle.adjustsFontSizeToFitWidth = true
        shabonBackGround.layer.cornerRadius = self.frame.width / 2
        shabonBackGround.layer.masksToBounds = true
        
        let color = comment["color"] as! String
        let red = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 0.4161761558)
        let blue = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 0.3145066353)
        let yellow = #colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 0.5292701199)
        
        switch color {
        case "赤":
            shabonBackGround.backgroundColor = red
        case "黄":
            shabonBackGround.backgroundColor = yellow
        case "青":
            shabonBackGround.backgroundColor = blue
        default: break
        }
        
        let nayami_comment = comment["nayami_comments"] as! [[String: Any]]
        for value in nayami_comment {
            print(value["yonda_flag"])
        }
        
        //まだ見てないコメントがある時にnew_flag
        let bool = comment["life_flag"] as! Bool
        if bool == false {
            let yonda = nayami_comment.filter { $0["yonda_flag"] as! Bool == false }
            if yonda.count > 0 {
                newNayami.image = UIImage(named: "new")
            }else{
                newNayami.image = nil
            }
        }else{
            let yonda = comment["splash_yonda_check"] as! [String: Any]
            let yonda_flag = yonda["yonda_flag"] as! Bool
            if !yonda_flag {
                newNayami.image = UIImage(named: "new")
            }else{
                newNayami.image = nil
            }
        }
        //悩みコメントの数のイメージを設定
        myShabonCount.image = UIImage(named: "number" + String(nayami_comment.count))
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
