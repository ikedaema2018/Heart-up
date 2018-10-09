//
//  NayamiCommentModel.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/10/09.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import Foundation

struct NayamiCommentModel: Codable {
    let id: Int
    let nayami_comment: String
    let stamp_id: Int
    let user_id: Int
    let yonda_flag: Bool
}
