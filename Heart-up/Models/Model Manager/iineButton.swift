//
//  iineButton.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/10/11.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import Foundation
import UIKit
// これだけ必要
class MyButton : UIButton{
    var nayamiOrReply: Int?
    var reactionId: Int?
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
