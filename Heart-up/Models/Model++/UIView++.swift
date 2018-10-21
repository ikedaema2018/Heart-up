//
//  UIView++.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/10/15.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit
import Foundation

class ModalView :UIView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
