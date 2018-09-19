//
//  UserInfoViewController.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/09/19.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var selfIntroduce: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.image = UIImage(named: "noel")
        selfIntroduce.layer.borderWidth = 1.0
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)

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
