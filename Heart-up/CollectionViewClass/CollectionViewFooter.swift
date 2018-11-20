//
//  CollectionViewFooter.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/09/18.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit

class bottomFooter: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews(){
        
        let white = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        backgroundColor = white
        
        addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1).isActive = true
        titleLabel.sizeToFit()
    }
    
    func changeColor(color: UIColor){
        backgroundColor = color
    }
    
    var titleLabel: UILabel = {
        var label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}
