//
//  ShabonContentsTableViewCell.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/10/01.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit
import SwiftyJSON

class ShabonContentsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userProfile: UIImageView!
    @IBOutlet weak var nayamiView: UIView!
    @IBOutlet weak var nayamiLabel: UILabel!
    @IBOutlet weak var toukou_day: UILabel!
    @IBOutlet weak var stampView: UIImageView!
    @IBOutlet weak var replyOutret: UIButton!
    @IBOutlet weak var replyView: UIView!
    @IBOutlet weak var replyLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var iineButton: UIButton!
    
    var locateId: String?
    var iineImage: MyButton!
    var sadImage: MyButton!
    var angryImage: MyButton!
    var reactionView: UIView!
    var shabonColor: String?
    var row: Int?
    var contentsTable: UITableView?
    //このシャボン玉の持ち主
    var ownerUserId: Int?
    //このシャボン玉が弾けてるか否か
    var lifeFlag = false
    
    //アニメーション中に二重送信させないための処理
    var pushFlag = false
    
    //リアクション画像の表示のところを先に定義
    
    @IBOutlet weak var iineReaction: UIImageView!
    @IBOutlet weak var sadReaction: UIImageView!
    @IBOutlet weak var angryReaction: UIImageView!
    
    var comment: JSON? {
        didSet {
            
            //もしlifeFlagがtrueならいいね!ボタンと返信ボタンをつけない
            if lifeFlag {
                iineButton.isHidden = true
                replyOutret.isHidden = true
            }
            //imageViewをタップできるように
//            userProfile.isUserInteractionEnabled = true
            //もし自分のcommentだったらいいね!ボタンをつけない
            guard let userId = UserDefaults.standard.string(forKey: "user_id") else {
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    appDelegate.showLoginStoryboard()
                }
                return
            }
            //なぜか前の方をstringにすることができない
            //自分のコメントにいいねができないように
//            if comment!["user_id"].int == Int(userId) {
//                iineButton.isHidden = true
//            }
            
            guard let comment = comment else {
                return
            }
            
            //iineボタンを押したら表示させる
            reactionView = UIView.init(frame: CGRect.init(x : self.iineButton.frame.origin.x + 55, y: self.iineButton.frame.origin.y - 20, width: 60, height: 30))
            reactionView.backgroundColor = UIColor.white
            reactionView.layer.borderWidth = 2
            reactionView.layer.cornerRadius = 3
            self.addSubview(reactionView)
            
            self.addSubview(iineReaction)
            
            self.addSubview(sadReaction)
            
            self.addSubview(angryReaction)
            
            
            iineImage = MyButton(frame: CGRect(x: 3, y: 3, width: 15, height: 25))
            iineImage.setBackgroundImage(UIImage(named: "heart"), for: .normal)
            iineImage.nayamiOrReply = 1
            iineImage.reactionId = 1
            iineImage.tag = comment["id"].int!
            iineImage.addTarget(self, action: #selector(self.iinePost), for: .touchDown)
            reactionView.addSubview(iineImage)
            
            sadImage = MyButton(frame: CGRect(x: 21, y: 3, width: 15, height: 25))
            sadImage.setBackgroundImage(UIImage(named: "sad"), for: .normal)
            sadImage.nayamiOrReply = 1
            sadImage.reactionId = 2
            sadImage.tag = comment["id"].int!
            sadImage.addTarget(self, action: #selector(self.iinePost), for: .touchDown)
            reactionView.addSubview(sadImage)
            
            angryImage = MyButton(frame: CGRect(x: 39, y: 3, width: 15, height: 25))
            angryImage.setBackgroundImage(UIImage(named: "angry"), for: .normal)
            angryImage.nayamiOrReply = 1
            angryImage.reactionId = 3
            angryImage.tag = comment["id"].int!
            angryImage.addTarget(self, action: #selector(self.iinePost), for: .touchDown)
            reactionView.addSubview(angryImage)
            reactionView.isHidden = true
            
            
            
            replyView.isHidden = true
            userProfile.isHidden = false
            nayamiView.isHidden = false
//            replyOutret.isHidden = false
            replyOutret.layer.cornerRadius = 13
            userProfile.clipsToBounds = true
        
            var reaction: [String: Int] = ["iine": 0, "sad": 0, "angry": 0]
            
            if !comment["reactions"].isEmpty {
                //もしいいねの数が1以上ならリアクションを表示
                for value in comment["reactions"] {
                    //もし自分がリアクションを投稿していたらいいね!ボタンを非表示
                    if Int(userId) == value.1["user_id"].int {
                        iineButton.isHidden = true
                    }
                    
                    let reactionId = value.1["reaction_id"].int!
                    if reactionId == 1 {
                        reaction["iine"] = reaction["iine"]! + 1
                    } else if reactionId == 2 {
                        reaction["sad"] = reaction["sad"]! + 1
                    } else if reactionId == 3 {
                        reaction["angry"] = reaction["angry"]! + 1
                    }
                }

                //もしいいねの数が1以上ならリアクションを表示
                for (key, value) in reaction {
                    key == "iine" && value > 0 ? iineDisplay() : ()
                    key == "sad" && value > 0 ? sadDisplay() : ()
                    key == "angry" && value > 0 ? angryDisplay() : ()
                }
            }
            
            let user_image = comment["user"]["profile_image"].string
            if user_image != nil {
                let image_path = user_image
                let url = "http://s3-ap-northeast-1.amazonaws.com/heartup/images/" + image_path!
                self.userProfile.downloadedFrom(link: url)
            }else{
                self.userProfile.image = UIImage(named: "myPage")
            }
            
            if let shabonColor = shabonColor {
                var color: UIColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 0.1816941353)
                switch shabonColor {
                case "青":
                    color = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 0.1816941353)
                case "赤":
                    color = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 0.1825770548)
                case "黄":
                    color = #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 0.1777076199)
                default:
                    print("シャボンカラーがないよ！")
                }
                nayamiLabel.backgroundColor = color
            }
            
            //文字列をDate型にformatするコピペ
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZ'"
            if let date = formatter.date(from: comment["created_at"].string!) {
                formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy年MM月dd日(EEE） HH時mm分", options: 0, locale: Locale(identifier: "ja_JP"))
                
                //ここで何時間前とか何日前とかを認識する処理を書く
                let span = -date.timeIntervalSinceNow
                
                
                if span/60/60/24 > 1 {
                    toukou_day.text = "\(String(format: "%.0f", span/60/60/24))日前"
                } else if span/60/60 > 1 {
                    toukou_day.text = "\(String(format: "%.0f", span/60/60))時間前"
                } else if span/60 > 1 {
                    toukou_day.text = "\(String(format: "%.0f", span/60))分前"
                } else {
                    toukou_day.text = "\(String(format: "%.0f", span))秒前"
                }
                
                
//                date型の日付を時刻のString型に変換
//                let dateStr = formatter.string(from: date).description
//                toukou_day.text = dateStr
                toukou_day.font = UIFont.systemFont(ofSize: 11)
            }
            
            if comment["nayami_comment"].string != nil {
                stampView.isHidden = true
                nayamiLabel.isHidden = false
                nayamiLabel.text = comment["nayami_comment"].string
                //            nayamiView.layer.cornerRadius = 20
                nayamiLabel.layer.borderWidth = 0.5
                nayamiLabel.layer.borderColor = UIColor.black.cgColor
                nayamiLabel.layer.cornerRadius = 5.0
            }
            
            if let stampId = comment["stamp_id"].int {
                nayamiLabel.isHidden = true
                stampView.isHidden = false
                if stampId == 1 {
                    stampView.image = UIImage(named: "awa")
                } else if stampId == 2 {
                    stampView.image = UIImage(named: "bittkuri")
                } else if stampId == 3 {
                    stampView.image = UIImage(named: "gurottuki-")
                } else if stampId == 4 {
                    stampView.image = UIImage(named: "ase")
                }
            }
        }
    }
    

    
    @IBAction func iineShow(_ sender: Any) {
        if reactionView.isHidden == true {
            reactionView.isHidden = false
        } else {
            reactionView.isHidden = true
            iineButton.setTitle("いいね！", for: .normal)
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func iinePost(sender: MyButton){
        if pushFlag == true {
            return
        }
        pushFlag = true
        //ここでクリックしたイメージをアニメーションさせる
        let reactionId = sender.reactionId!
        reactionId == 1 ? iineReaction.image = UIImage(named: "heart") : ()
        reactionId == 2 ? sadReaction.image = UIImage(named: "sad") : ()
        reactionId == 3 ? angryReaction.image = UIImage(named: "angry") : ()
        //ここでクリックしたイメージをアニメーションさせる
        UIView.transition(with: sender, duration: 1.0, options: [.transitionCrossDissolve, .autoreverse], animations: {
            sender.isHidden = true
        }) { _ in
            self.iinePost2(sender: sender, row: self.row!)
            self.pushFlag = false
            sender.isHidden = false
            self.iineButton.isHidden = true
        }
    }
    
    private func iinePost2(sender: MyButton, row: Int){
        reactionView.isHidden = true
        iineButton.setTitle("いいね！", for: .normal)
        
        Reaction.reactionPost(commentId: sender.tag, nayamiOrReply: sender.nayamiOrReply, reactionId: sender.reactionId, callback: { error in
            if let error = error {
                if let message = error["message"] as? String {
                    ShabonContentsViewController().showAlert(message: message, hide: {})
                } else {
                    ShabonContentsViewController().showAlert(message: "エラーが発生しました", hide: {})
                }
                return
            }
        })
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iineReaction.image = nil
        sadReaction.image = nil
        angryReaction.image = nil
    }
    
    private func iineDisplay(){
        iineReaction.image = UIImage(named: "heart")
    }
    
    private func sadDisplay(){
        sadReaction.image = UIImage(named: "sad")
    }
    
    private func angryDisplay(){
        angryReaction.image = UIImage(named: "angry")
    }
}
