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
    
    var iineImage: MyButton!
    var sadImage: MyButton!
    var angryImage: MyButton!
    
    var reactionView: UIView!
    
    
    var shabonColor: String?
    var reply: JSON? {
        didSet {
            guard let reply = reply else { return }
            commentLabel.text = reply["reply_comment"].string
            let user_image = reply["user"]["profile_image"].string
            //iineボタンを押したら表示させる
            reactionView = UIView.init(frame: CGRect.init(x : self.iineButton.frame.origin.x - 10, y: self.iineButton.frame.origin.y - 25, width: 60, height: 30))
            reactionView.backgroundColor = UIColor.white
            reactionView.layer.borderWidth = 2
            reactionView.layer.cornerRadius = 3
            self.addSubview(reactionView)
            
            
            iineImage = MyButton(frame: CGRect(x: 3, y: 3, width: 15, height: 25))
            iineImage.setBackgroundImage(UIImage(named: "heart"), for: .normal)
            iineImage.nayamiOrReply = 2
            iineImage.reactionId = 1
            iineImage.addTarget(self, action: #selector(self.iinePost), for: .touchDown)
            reactionView.addSubview(iineImage)
            
            sadImage = MyButton(frame: CGRect(x: 21, y: 3, width: 15, height: 25))
            sadImage.setBackgroundImage(UIImage(named: "sad"), for: .normal)
            sadImage.nayamiOrReply = 2
            sadImage.reactionId = 2
            sadImage.addTarget(self, action: #selector(self.iinePost), for: .touchDown)
            reactionView.addSubview(sadImage)
            
            angryImage = MyButton(frame: CGRect(x: 39, y: 3, width: 15, height: 25))
            angryImage.setBackgroundImage(UIImage(named: "angry"), for: .normal)
            angryImage.nayamiOrReply = 2
            angryImage.reactionId = 3
            angryImage.addTarget(self, action: #selector(self.iinePost), for: .touchDown)
            reactionView.addSubview(angryImage)
            reactionView.isHidden = true
            
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
    
    @IBAction func iineShow(_ sender: Any) {
        if reactionView.isHidden == true {
            reactionView.isHidden = false
            iineButton.setTitle("CLOSE", for: .normal)
        } else {
            reactionView.isHidden = true
            iineButton.setTitle("いいね！", for: .normal)
        }
    }
    
    
    @objc func iinePost(sender: MyButton){
        //ここでクリックしたイメージをアニメーションさせる
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
            //アラートはなしで,アニメでmessengerのような表示にしたい
            
            // コメントデータの再読み込み.
            //fetchDataのせいでdequeueのあれでできなくなってる
            ShabonContentsViewController().fetchData()
        })
        
    }
    
}
