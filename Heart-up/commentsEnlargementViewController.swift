//
//  commentsEnlargementViewController.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/11/09.
//  Copyright © 2018 kei maeda. All rights reserved.
//

import UIKit

class commentsEnlargementViewController: UIViewController {
    var labelText: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backColor = #colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 0.409380351)
        view.backgroundColor = backColor
        
        var commentView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 50, height: self.view.frame.width - 50))
        commentView.backgroundColor = UIColor.white
        commentView.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2)
        commentView.layer.borderWidth = 10
        let borderColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 0.5)
        commentView.layer.borderColor = borderColor.cgColor
        commentView.layer.cornerRadius = 10
        commentView.layer.masksToBounds = true

        var commentLabel = UILabel(frame: CGRect( x: 0, y: 0, width: commentView.frame.width - 50, height: commentView.frame.width - 50))
        commentLabel.text = labelText
        commentLabel.backgroundColor = UIColor.white
        commentLabel.center = CGPoint(x: commentView.frame.width / 2, y: commentView.frame.height / 2)
        commentLabel.numberOfLines = 3
        commentView.addSubview(commentLabel)
        self.view.addSubview(commentView)
        
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 75))
        backButton.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height - self.view.frame.height / 5)
        backButton.layer.cornerRadius = 10
        backButton.setTitle("back", for: .normal)
        backButton.backgroundColor = UIColor.blue
        backButton.addTarget(self, action: #selector(commentsEnlargementViewController.back(_:)), for: .touchUpInside)
        view.addSubview(backButton)
        // Do any additional setup after loading the view.
    }
    
    @objc func back(_ sender: UIButton){
        self.dismiss(animated: false, completion: nil)
    }
}
