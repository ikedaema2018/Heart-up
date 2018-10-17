//
//  HappyGraduationViewController.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/10/13.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation
import AVFoundation

class HappyGraduationViewController: UIViewController {
    var locates: JSON?
    var place: String = ""
    var kyori: Double?
    var player: AVAudioPlayer?
    
    @IBOutlet weak var happyGraduation: UIImageView!
    @IBOutlet weak var breakLocate: UILabel!
    @IBOutlet weak var moveLocate: UILabel!
    @IBOutlet weak var breakTime: UILabel!
    @IBOutlet weak var nayamiDetail: UILabel!
    @IBOutlet weak var totalReaction: UILabel!
    @IBOutlet weak var iineKaisuu: UILabel!
    @IBOutlet weak var angryKaisuu: UILabel!
    @IBOutlet weak var sadKaisuu: UILabel!
    @IBOutlet weak var bubbles: UIImageView!
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var detailBorder: UIView!
    @IBOutlet weak var detailBackground: UIView!
    @IBOutlet weak var returnButton: UIButton!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //卒業おめでとうの画像
        happyGraduation.image = UIImage(named: "happy_graduation")
        happyGraduation.contentMode = UIViewContentMode.scaleAspectFit
        
        //破裂するまでの時間を表示
        let createDay = locates!["created_at"].string!
        let breakDay = locates!["updated_at"].string!
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZ'"
        if let cteateDate = formatter.date(from: createDay), let breakDate = formatter.date(from: breakDay) {
            let span = -cteateDate.timeIntervalSince(breakDate)
            if span/60/60/24 > 1 {
                breakTime.text = "\(String(format: "%.0f", span/60/60/24))日"
            } else if span/60/60 > 1 {
                breakTime.text = "\(String(format: "%.0f", span/60/60))時間"
            } else if span/60 > 1 {
                breakTime.text = "\(String(format: "%.0f", span/60))分"
            } else {
                breakTime.text = "\(String(format: "%.0f", span))秒"
            }
        }
        
        //悩みのタイトル
        nayamiDetail.text = locates!["nayami"].string
        nayamiDetail.sizeToFit()
//        nayamiDetail.layer.borderWidth = 1
        
        //破裂した場所と移動した距離、破裂するまでの時間
        getLocate()
        
        //あなた悩みは解決しました
        bubbles.image = UIImage(named: "bubbles")
        bubbles.contentMode = UIViewContentMode.scaleAspectFit
        
        //ボーダー
        //上線のCALayerを作成
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: detailBorder.frame.width, height: 1.0)
        topBorder.backgroundColor = UIColor.lightGray.cgColor
        //作成したViewに上線を追加
        detailBorder.backgroundColor = UIColor.lightGray
        //detailにバックグランド
        let color = #colorLiteral(red: 0.4500938654, green: 0.9813225865, blue: 0.4743030667, alpha: 0.2431774401)
        detailBackground.backgroundColor = color
        
        //悩みのタイトル
        titleImage.image = UIImage(named: "title")
        
        //戻るボタン
        returnButton.setImage(UIImage(named: "return2"), for: .normal)

        //リアクションを大量に出す
        reactionParty(locates)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        for i in 1...8 {
            let fireFlowerImage = UIImageView()
            self.view.addSubview(fireFlowerImage)
            self.view.sendSubview(toBack: fireFlowerImage)
            //Timerで3秒に一回花火が咲く
            Timer.scheduledTimer(withTimeInterval: (TimeInterval(3 + i)), repeats: true) { (_ ) in
                self.fireFlowerStart(fireFlowerImage)
            }
        }
        //音を鳴らす
                let soundNum = Int(arc4random_uniform(2))
                let soundTitle: [String] = ["christmasnomachi", "rokuninnorappafuki", "sunadokeiseiun"]
                playSound(soundTitle[soundNum])
        
        //戻るを点滅
        var lightFlag = false
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { (_) in
            if lightFlag { self.returnButton.setImage(nil, for: .normal)}
            else { self.returnButton.setImage(UIImage( named: "return2"), for: .normal) }
            lightFlag = !lightFlag
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func returnContents(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

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
            if !nayamiComment.1["reply_comments"].isEmpty {
                for reply in nayamiComment.1["reply_comments"] {
                    if !reply.1["reactions"].isEmpty {
                        for reaction in reply.1["reactions"] {
                            reaction.1["reaction_id"].int! == 1 ? reactions["iine"]! += 1 : ()
                            reaction.1["reaction_id"].int! == 2 ? reactions["sad"]! += 1 : ()
                            reaction.1["reaction_id"].int! == 3 ? reactions["angry"]! += 1 : ()
                        }
                    }
                }
            }
        }

        //reactionsを(key,value)で回してその分imageViewを作成
        var totalReactions = 0
        for (key, value) in reactions {
            //        リアクションの総数を表示
            totalReactions += value
            switch key {
            case "iine":
                iineKaisuu.text = "\(String(value))回"
                reactionDisplay(count: value, reactionId: 1)
            case "sad":
                reactionDisplay(count: value, reactionId: 2)
                sadKaisuu.text = "\(String(value))回"
            case "angry":
                reactionDisplay(count: value, reactionId: 3)
                angryKaisuu.text = "\(String(value))回"
            default:
                ()
            }
        }
        totalReaction.text = "\(totalReactions)回"
    }
    
    //いいね、悲しい、怒る,それぞれの画像表示のメソッド
    private func reactionDisplay(count: Int, reactionId: Int){
        for _ in 0..<count {
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
            self.view.sendSubview(toBack: reactionImage)
        }
    }
    
    private func getLocate(){
        //破裂した場所、移動した場所を出す
        guard let longitude = self.locates!["keido"].double, let latitude = self.locates!["ido"].double else {
        return
        }

        //リバースジオロケートで緯度経度
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)

        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let placemarks = placemarks {

            if let pm = placemarks.first {
            //placeを初期化
            self.place = ""
            self.place += pm.administrativeArea ?? ""
            self.place += pm.locality ?? ""
            self.place += pm.subLocality ?? ""
            }
            self.breakLocate.text = self.place
        }
            
        //もし["first_locates"]がnilじゃなかったら距離を取得
        let firstLocate = self.locates!["first_locate"]

        guard let fLatitude = firstLocate["ido"].double, let fLongitude = firstLocate["keido"].double else {
        return
        }
        self.kyori = Distance.distance(current: (la: latitude, lo: longitude), target: (la: fLatitude, lo: fLongitude))
            self.moveLocate.text = "\(String(format: "%.0f", self.kyori!))km"
            
        }
    }
    //花を咲かせる
    @objc private func fireFlowerStart(_ fireFlowerImage: UIImageView){
        //fireFlowerの中心を定義
        let imgX = CGFloat(arc4random_uniform((UInt32(self.view.frame.width))))
        let imgY = CGFloat(arc4random_uniform((UInt32(self.view.frame.height))))
        let imageSize = CGFloat(arc4random_uniform(UInt32(100)) + 100)
        let fireFlowerNumber = arc4random_uniform(7)
        let fireImage = UIImage(named: "fireFlower" + String(fireFlowerNumber))
        
        fireFlowerImage.frame = CGRect(x: 0, y: 0, width: imageSize, height: imageSize)
        fireFlowerImage.center = CGPoint(x: imgX, y: imgY)
        fireFlowerImage.image = fireImage
        
        //音を鳴らす
//        let soundNum = Int(arc4random_uniform(2))
//        let soundTitle: [String] = ["bomb", "short_bomb"]
//        playSound(soundTitle[soundNum])
    }
}

extension HappyGraduationViewController {
    
    
    private func playSound(_ sound: String) {
        if let sound = NSDataAsset(name: sound) {
            player = try? AVAudioPlayer(data: sound.data)
            player?.play() // → これで音が鳴る
        }
    }
    
}
