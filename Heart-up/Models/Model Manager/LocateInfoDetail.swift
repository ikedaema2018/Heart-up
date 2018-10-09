//
//  LocateInfoDetail.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/10/09.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import Foundation

struct LocateInfoDetail: Decodable {
    let id: Int
    let ido: Double
    let keido: Double
    let nayami: String
    let color: String
    let life_flag: Bool
}
