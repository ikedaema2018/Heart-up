//
//  HappyGraduationViewController.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/10/13.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit
import SwiftyJSON

class HappyGraduationViewController: UIViewController {
    var locates: JSON?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        print(locates)
        
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
