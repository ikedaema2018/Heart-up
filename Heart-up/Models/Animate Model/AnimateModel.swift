//
//  AnimateModel.swift
//  
//
//  Created by 前田啓 on 2018/10/18.
//

import Foundation
import UIKit
import AVFoundation

class AnimateModel: NSObject {
    
    @objc class func reactionAction(reactionView: UIImageView){
        let random = Int(arc4random_uniform(5))
        switch random {
        case 1:
            tateyure(reactionView: reactionView)
        case 2:
            yokoyure(reactionView: reactionView)
        case 3:
            hanekaeri(reactionView: reactionView)
        case 4:
            guruguru(reactionView: reactionView)
        default:
            kurukuru(reactionView: reactionView)
        }
    }
    
    class func tateyure(reactionView: UIImageView){
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveEaseIn, .autoreverse], animations: {
            reactionView.center.y += 100.0
        }) { _ in
            reactionView.center.y -= 100.0
        }
    }
    
    class func yokoyure(reactionView: UIImageView) {
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
            reactionView.center.x += 50
        }) { _ in
            reactionView.center.x -= 50
        }
    }
    
    class func hanekaeri(reactionView: UIImageView) {
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0.0, options: .autoreverse, animations: {
            reactionView.center.y += 100.0
            reactionView.bounds.size.height += 30.0
            reactionView.bounds.size.width += 30.0
        }) { _ in
            reactionView.center.y -= 100.0
            reactionView.bounds.size.height -= 30.0
            reactionView.bounds.size.width -= 30.0
        }
    }
    
    class func kurukuru(reactionView: UIImageView) {
        var times = 0
        func kurururu(reactionView: UIImageView){
            times += 1
            UIView.transition(with: reactionView, duration: 0.5, options: [.transitionFlipFromBottom], animations: nil, completion: {_ in
                if times == 5 { return }
                kurururu(reactionView: reactionView)
            })
        }
        kurururu(reactionView: reactionView)
        
    }
    
    class func guruguru(reactionView: UIImageView) {
        UIView.animateKeyframes(withDuration: 2.0, delay: 0.0, options: [.autoreverse], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25, animations: {
                reactionView.center.y += 100.0
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.1, animations: {
                reactionView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25, animations: {
                reactionView.center.x += 100.0
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.1, animations: {
                reactionView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.25, animations: {
                reactionView.center.y -= 100.0
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.1, animations: {
                reactionView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI + M_PI_2))
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25, animations: {
                reactionView.center.x -= 100.0
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.1, animations: {
                reactionView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI * 2.0))
            })
            
        }, completion: nil)
    }
    
}
