//
//  LocateInfo.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/08/24.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit

class LocateInfo: NSObject {
    let nayami: String
    let ido: String
    let keido: String
    let color: String
    
    func printName() {
        print(nayami)
        print(ido)
        print(keido)
        print(color)
    }
    
    init(nayami: String, ido: String, keido: String, color: String) {
        self.nayami = nayami
        self.ido = ido
        self.keido = keido
        self.color = color
        super.init()
        printName()
    }
}
