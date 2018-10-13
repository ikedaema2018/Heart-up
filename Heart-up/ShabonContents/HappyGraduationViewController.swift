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
                    reaction.1["reaction_id"].int! == 1 ? reactions["iine"]! += 1 : ()
                    reaction.1["reaction_id"].int! == 2 ? reactions["sad"]! += 1 : ()
                    reaction.1["reaction_id"].int! == 3 ? reactions["angry"]! += 1 : ()
                }
            }
        }
        //reactionsを(key,value)で回してその分imageViewを作成
        for (key, value) in reactions {
            switch key {
            case "iine":
                reactionDisplay(count: value, reactionId: 1)
            case "sad":
                reactionDisplay(count: value, reactionId: 2)
            case "angry":
                reactionDisplay(count: value, reactionId: 3)
            default:
                ()
            }
        }
    }
    
    //いいね、悲しい、怒る,それぞれの画像表示のメソッド
    private func reactionDisplay(count: Int, reactionId: Int){
        for _ in 0..<count {
            print("-----------------------回数---------------------------------")
            //reactionの高さをランダムで定義
            let imgX = CGFloat(arc4random_uniform((UInt32(self.view.frame.width))))
            let imgY = CGFloat(arc4random_uniform((UInt32(self.view.frame.height))))

            let reactionImage = UIImageView()
            // 画像の中心を画面の中心に設定
            reactionImage.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            reactionImage.center = CGPoint(x:imgX, y:imgY)
            
            switch reactionId {
            case 1:
                reactionImage.image = UIImage(named: "heart")
            case 2:
                reactionImage.image = UIImage(named: "sad")
            case 3:
                reactionImage.image = UIImage(named: "angry")
            default:
                ()
            }
            self.view.addSubview(reactionImage)
        }
    }
}
