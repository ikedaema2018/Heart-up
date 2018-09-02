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
    @IBOutlet weak var commentInput: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func commentAction(_ sender: Any) {
        guard let anno_id = locateId else {
            return
        }
        guard let annoId = Int(anno_id) else {
            return
        }
        
        guard let comment = commentInput.text else {
            errorLabel.isHidden = false
            errorLabel.text = "コメントを入力してから送信してね"
            return
        }
        if comment == "" {
            errorLabel.isHidden = false
            errorLabel.text = "コメントを入力してから送信してね"
            return
        }
        
        //ポストします
        NayamiComment.nayamiCommentPost(locate_info_id: annoId, comment: comment, callback: { error in
            if let error = error {
                if let message = error["message"] as? String {
                    self.showAlert(message: message, hide: {})
                } else {
                    self.showAlert(message: "エラーが発生しました", hide: {})
                }
                return
            }
            self.showAlert(message: "投稿しました", hide: {})
        })
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentInput.delegate = self
        commentInput.placeholder = "この悩みにコメントする"
        errorLabel.isHidden = true
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

extension detailShabonViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
