//
//  HappyGraduationViewController.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/10/13.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit
import SwiftyJSON

class HappyGraduationViewController: UIViewController {
    var locates: JSON?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)

        //リアクションを大量に出す
        reactionParty(locates)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HappyGraduationViewController {
    private func reactionParty(_ locates: JSON?) {
        guard let locates = locates else {
            return
        }
        //まずはリアクションをハッシュで整形
        var reactions = ["iine": 0, "sad": 0, "angry": 0]
        for nayamiComment in locates["nayami_comments"] {
            if !nayamiComment.1["reactions"].isEmpty {
                for reaction in nayamiComment.1["reactions"] {
                    print(reaction.0)
                    reaction.1["reaction_id"].int! == 1 ? reactions["iine"]! += 1 : ()
                    reaction.1["reaction_id"].int! == 2 ? reactions["sad"]! += 1 : ()
                    reaction.1["reaction_id"].int! == 3 ? reactions["angry"]! += 1 : ()
                }
            }
        }
        //reactionsを(key,value)で回してその分imageViewを作成
        for (key, value) in reactions {
            
        }
        //reactionの高さをランダムで定義
        let imgHeight = Float(arc4random_uniform((UInt32(self.view.frame.height))))
        let imgWidth = Float(arc4random_uniform((UInt32(self.view.frame.width))))
    }
}
