//
//  UserTapGestureRecognizer.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/10/13.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit
import AVFoundation

class UserTapGestureRecognizer: UITapGestureRecognizer {
    var userId: Int?
    var reactionView: UIImageView?
    var happyAudio: AVAudioPlayer?
}
