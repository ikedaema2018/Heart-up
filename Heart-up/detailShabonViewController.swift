//
//  detailShabonViewController.swift
//  
//
//  Created by 前田啓 on 2018/08/29.
//

import UIKit

class detailShabonViewController: UIViewController {
    
    //idを定義
    var locateId: String?
    @IBOutlet weak var whoNayami: UILabel!
    @IBOutlet weak var nayamiLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //ここにIDで検索する処理をかく
        guard let annoId = locateId else {
            return
        }
        
        StockLocateInfos.getDetailLocation(id: annoId, callback: {error, locate in
            
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
            
            self.whoNayami.text = locate["user"]["user_name"].string
            self.nayamiLabel.text = locate["nayami"].string
        })
        
        
        
        
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
