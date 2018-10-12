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
    
    
    var iineImage: MyButton!
    var sadImage: MyButton!
    var angryImage: MyButton!
    var reactionView: UIView!
    var shabonColor: String?
    
    //リアクション画像の表示のところを先に定義
    var iineReaction: UIImageView!
    var sadReaction: UIImageView!
    var angryReaction: UIImageView!
    
    
    //アニメーション中に二重送信させないための処理
    var pushFlag = false
    
    var comment: JSON? {
        didSet {
            
            guard let comment = comment else {
                return
            }
            
            //ReactionImageの空を先に定義
            iineReaction = UIImageView()
            iineReaction.image = nil
            iineReaction.frame = CGRect(x: self.frame.width - 20, y: self.frame.origin.y + 17, width: 15, height: 15)
            self.addSubview(iineReaction)
            
            sadReaction = UIImageView()
            sadReaction.image = nil
            sadReaction.frame = CGRect(x: self.frame.width - 20, y: self.frame.origin.y + 17, width: 15, height: 15)
            self.addSubview(sadReaction)
            
            angryReaction = UIImageView()
            angryReaction.image = nil
            angryReaction.frame = CGRect(x: self.frame.width - 20, y: self.frame.origin.y + 34, width: 15, height: 15)
            self.addSubview(angryReaction)
            
            //iineボタンを押したら表示させる
            reactionView = UIView.init(frame: CGRect.init(x : self.iineButton.frame.origin.x + 55, y: self.iineButton.frame.origin.y - 20, width: 60, height: 30))
            reactionView.backgroundColor = UIColor.white
            reactionView.layer.borderWidth = 2
            reactionView.layer.cornerRadius = 3
            self.addSubview(reactionView)
            
            
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
            replyOutret.isHidden = false
            replyOutret.layer.cornerRadius = 13
            userProfile.clipsToBounds = true
        
            var reaction: [String: Int] = ["iine": 0, "sad": 0, "angry": 0]
            
            if !comment["reactions"].isEmpty {
                for value in comment["reactions"] {
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
                for value in comment["reactions"] {
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
                
//                if reaction["iine"]! > 0 {
//                    let iineReaction = UIImageView(image: UIImage(named: "heart"))
//                    iineReaction.frame = CGRect(x: self.frame.width - 20, y: self.frame.origin.y + 2, width: 15, height: 15)
//                    self.addSubview(iineReaction)
//                } else if reaction["sad"]! > 0 {
//                    let sadReaction = UIImageView(image: UIImage(named: "sad"))
//                    sadReaction.frame = CGRect(x: self.frame.width - 20, y: self.frame.origin.y + 17, width: 15, height: 15)
//                    self.addSubview(sadReaction)
//                } else if reaction["angry"]! > 0 {
//                    let angryReaction = UIImageView(image: UIImage(named: "angry"))
//                    angryReaction.frame = CGRect(x: self.frame.width - 20, y: self.frame.origin.y + 34, width: 15, height: 15)
//                    self.addSubview(angryReaction)
//                }
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
                let dateStr = formatter.string(from: date).description
                toukou_day.text = dateStr
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
    
    var reply: JSON? {
        didSet {
            userProfile.isHidden = true
            nayamiView.isHidden = true
            replyOutret.isHidden = true
            replyView.isHidden = false
            
            guard let reply = reply else { return }
            replyLabel.text = reply["reply_comment"].string
            let user_image = reply["user"]["profile_image"].string
            if user_image != nil {
                let image_path = user_image
                let url = "http://s3-ap-northeast-1.amazonaws.com/heartup/images/" + image_path!
                self.userImage.downloadedFrom(link: url)
            }else{
                self.userImage.image = UIImage(named: "myPage")
            }
            if let shabonColor = shabonColor {
                var color: UIColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 0.1816941353)
                switch shabonColor {
                case "青":
                    color = #colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 0.1478756421)
                case "赤":
                    color = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 0.1504708904)
                case "黄":
                    color = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 0.154885488)
                default:
                    print("シャボンカラーがないよ！")
                }
                replyLabel.backgroundColor = color
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
        //ここでクリックしたイメージをアニメーションさせる
        
        if pushFlag == true {
            return
        }
        pushFlag = true
        //ここでクリックしたイメージをアニメーションさせる
        UIView.transition(with: sender, duration: 1.0, options: [.transitionCrossDissolve, .autoreverse], animations: {
            sender.isHidden = true
        }) { _ in
            self.iinePost2(sender: sender)
            self.pushFlag = false
            sender.isHidden = false
        }
    }
    
    private func iinePost2(sender: MyButton){
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
            // コメントデータの再読み込み.
            //fetchDataのせいでdequeueのあれでできなくなってる
            ShabonContentsViewController().fetchData()
        })
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
