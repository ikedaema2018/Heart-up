//
//  detailShabonViewController.swift
//  
//
//  Created by 前田啓 on 2018/08/29.
//

import UIKit

class detailShabonViewController: UIViewController {
    
    //idを定義
    var title: String?
    var subTitle: String?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if title != nil {
            
        }
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
