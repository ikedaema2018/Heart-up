//
//  Annotation.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/09/05.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit
import MapKit

class CustomAnnotation: MKPointAnnotation {
    var color: Dictionary<String, AnyObject>!
    var locateId: [String: AnyObject]!
}

class UserAnnotation : MKPointAnnotation {
    var userImage: Dictionary<String, AnyObject>?
    var userId: [String: AnyObject]!
}
