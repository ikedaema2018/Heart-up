//
//  replyCommentTableViewCell.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/10/08.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit
import SwiftyJSON

class replyCommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userProfile: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var iineButton: UIButton!
    @IBOutlet weak var iineReaction: UIImageView!
    @IBOutlet weak var sadReaction: UIImageView!
    @IBOutlet weak var angryReaction: UIImageView!
    
    var iineImage: MyButton!
    var sadImage: MyButton!
    var angryImage: MyButton!
    var reactionView: UIView!
    var row: Int?
    
    //アニメーション中に二重送信させないための処理
    var pushFlag = false
    
    
    var shabonColor: String?
    var reply: JSON? {
        didSet {
            //imageViewをタップできるように
            userProfile.isUserInteractionEnabled = true
            
            guard let reply = reply else { return }
            
            //もし自分のcommentだったらいいね!ボタンをつけない
            guard let userId = UserDefaults.standard.string(forKey: "user_id") else {
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    appDelegate.showLoginStoryboard()
                }
                return
            }
            
            let user_image = reply["user"]["profile_image"].string
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
                    color = #colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 0.1478756421)
                case "赤":
                    color = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 0.1504708904)
                case "黄":
                    color = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 0.154885488)
                default:
                    print("シャボンカラーがないよ！")
                }
                commentLabel.backgroundColor = color
            }
            commentLabel.layer.borderColor = UIColor.black.cgColor
            commentLabel.layer.borderWidth = 1
            commentLabel.layer.cornerRadius = 5
            commentLabel.layer.masksToBounds = true
            commentLabel.text = reply["reply_comment"].string
            
            //reaction表示のための
            var reaction: [String: Int] = ["iine": 0, "sad": 0, "angry": 0]
            
            if !reply["reactions"].isEmpty {
                //もしいいねの数が1以上ならリアクションを表示
                for value in reply["reactions"] {
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
    @IBAction func iineButtonClick(_ sender: Any) {
        //iineボタンを押したら表示させる
        reactionView = UIView.init(frame: CGRect.init(x : self.iineButton.frame.origin.x, y: self.iineButton.frame.origin.y - 20, width: 60, height: 30))
        reactionView.backgroundColor = UIColor.white
        reactionView.layer.borderWidth = 2
        reactionView.layer.cornerRadius = 3
        self.addSubview(reactionView)
        iineImage = MyButton(frame: CGRect(x: 3, y: 3, width: 15, height: 25))
        iineImage.setBackgroundImage(UIImage(named: "heart"), for: .normal)
        iineImage.nayamiOrReply = 2
        iineImage.reactionId = 1
        iineImage.tag = reply!["id"].int!
        iineImage.addTarget(self, action: #selector(self.iinePost), for: .touchDown)
        reactionView.addSubview(iineImage)
        
        sadImage = MyButton(frame: CGRect(x: 21, y: 3, width: 15, height: 25))
        sadImage.setBackgroundImage(UIImage(named: "sad"), for: .normal)
        sadImage.nayamiOrReply = 2
        sadImage.reactionId = 2
        sadImage.tag = reply!["id"].int!
        sadImage.addTarget(self, action: #selector(self.iinePost), for: .touchDown)
        reactionView.addSubview(sadImage)
        
        angryImage = MyButton(frame: CGRect(x: 39, y: 3, width: 15, height: 25))
        angryImage.setBackgroundImage(UIImage(named: "angry"), for: .normal)
        angryImage.nayamiOrReply = 2
        angryImage.reactionId = 3
        angryImage.tag = reply!["id"].int!
        angryImage.addTarget(self, action: #selector(self.iinePost), for: .touchDown)
        reactionView.addSubview(angryImage)
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
            //ここでエラー
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
