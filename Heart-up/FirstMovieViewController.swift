//
//  FirstMovieViewController.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/10/06.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit
import AVFoundation

class FirstMovieViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Bundle Resourcesからsample.mp4を読み込んで再生
        let path = Bundle.main.path(forResource: "shabonView", ofType: "mp4")!
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        player.play()
        
        
        // AVPlayer用のLayerを生成
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.bounds
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.zPosition = -1 // ボタン等よりも後ろに表示
        view.layer.insertSublayer(playerLayer, at: 0) // 動画をレイヤーとして追加

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
