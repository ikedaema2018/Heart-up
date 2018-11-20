import UIKit
import AVFoundation

class AVPlayer {
    
    class func playSound2(_ sound: String,_ player: AVAudioPlayer?) {
        if let sound = NSDataAsset(name: sound) {
            var player = player
            player = try? AVAudioPlayer(data: sound.data)
            player?.play() // → これで音が鳴る
        }
    }
    
    // 音楽コントローラ AVAudioPlayerを定義(変数定義、定義実施、クリア）
    class func audioPlayerDif(_ player: AVAudioPlayer?){
        // 音声ファイルのパスを定義 ファイル名, 拡張子を定義
        let audioPath = Bundle.main.path(forResource: "rpb", ofType: "mp3")!
        var player = player
        //ファイルが存在しない、拡張子が誤っている、などのエラーを防止するために実行テスト(try)する。
        do{
            //tryで、ファイルが問題なければ player変数にaudioPathを定義
            try player = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath) as URL)
        }catch{
            //エラー処理
        }
    }
    
}
