//
//  MyShabonDetailViewController.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/09/06.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit

class MyShabonDetailViewController: UIViewController {
    var id: String?
    var models: [[String: String]] = [
        ["mainTitle": "aaa", "subTitle": "bbb"],
        ["mainTitle": "ccc", "subTitle": "ccc"]
        ]
    
    @IBOutlet weak var MyShabonDetailCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        guard let shabonId = id else {
            return
        }
        
        StockLocateInfos.getDetailLocation(id: shabonId, callback: {error, locate in
            
            if let error = error {
                if let message = error["message"] as? String {
                    print(message)
                    print("不明なエラーが発生しました")
                } else {
                    print("不明なエラーが発生しました")
                }
                return
            }
            
            guard let locate = locate else {
                return
            }
            
//            for comment in locate["nayami_comments"] {
//                print(comment.1["nayami_comment"])
//            }
            print(locate)
        })
        
        MyShabonDetailCollection.dataSource = self
        
        //collectionTableの設定
        MyShabonDetailCollection.register(UINib(nibName: "MyShabonDetailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MyShabonDetailCell")
        
        // セルの大きさを設定
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: MyShabonDetailCollection.frame.width, height: 100)
        MyShabonDetailCollection.collectionViewLayout = layout
        
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

extension MyShabonDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyShabonDetailCell", for: indexPath)
        if let cell = cell as? MyShabonDetailCollectionViewCell {
            cell.setupCell(model: models[indexPath.row])
        }
        return cell
    }
    
    
    
}
