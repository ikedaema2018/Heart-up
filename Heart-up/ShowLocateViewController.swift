//
//  ShowLocateViewController.swift
//  
//
//  Created by 前田啓 on 2018/08/24.
//

import UIKit

class ShowLocateViewController: UIViewController {
    
    @IBOutlet weak var ido: UILabel!
    @IBOutlet weak var keido: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        StockLocateInfos.getLocate()
        
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
